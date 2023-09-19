local prs = require(".")

local function assertEquals(expected, actual)
  assert(expected == actual, string.format("expected: %s, was: %s", expected, actual))
end

local function testVisitor()
  local self = {}

  local summaries = {}
  local prs = {}
  local reviews = {}
  local checks = {}

  function self.summary(state, count)
    table.insert(summaries, { state, count })
  end

  function self.pr(state, title, url)
    table.insert(prs, { state, title, url })
  end

  function self.review(state, name, url, updatedAt)
    table.insert(reviews, { state, name, url, updatedAt })
  end

  function self.check(state, title, url)
    table.insert(checks, { state, title, url })
  end

  function self.assertSummaries(length)
    assertEquals(length, #summaries)
    return self
  end

  function self.assertPrs(length)
    assertEquals(length, #prs)
    return self
  end

  function self.assertReviews(length)
    assertEquals(length, #reviews)
    return self
  end

  function self.assertChecks(length)
    assertEquals(length, #checks)
    return self
  end

  function self.assertSummary(state, count)
    local summary = table.remove(summaries, 1)
    assertEquals(state, summary[1])
    assertEquals(count, summary[2])
    return self
  end

  function self.assertPr(state, title, url)
    local pr = table.remove(prs, 1)
    assertEquals(state, pr[1])
    assertEquals(title, pr[2])
    assertEquals(url, pr[3])
    return self
  end

  function self.assertReview(state, name, url, updatedAt)
    local review = table.remove(reviews, 1)
    assertEquals(state, review[1])
    assertEquals(name, review[2])
    assertEquals(url, review[3])
    assertEquals(updatedAt or os.time({ year = 1970, month = 1, day = 1, hour = 0, min = 0, sec = 0 }) - 18000, review[4])
    return self
  end

  function self.assertCheck(state, title, url)
    local check = table.remove(checks, 1)
    assertEquals(state, check[1])
    assertEquals(title, check[2])
    assertEquals(url, check[3])
    return self
  end

  return self
end

local function response()
  local self = {}

  local nodes = {}

  function self.with(pr)
    table.insert(nodes, pr.build())
    return self
  end

  function self.build()
    return nodes
  end

  return self
end

local function pr(title, url)
  local self = {}

  local reviewNodes = {}
  local commitStatusContexts = {}

  function self.review(state, name, url, updatedAt)
    table.insert(reviewNodes, {
      author = { name = name or "NAME" },
      state = state or "APPROVED",
      url = url or "URL",
      updatedAt = updatedAt or "1970-01-01T00:00:00Z",
    })
    return self
  end

  function self.check(state, title, url)
    table.insert(commitStatusContexts, {
      state = state or "SUCCESS",
      targetUrl = url or "URL",
      context = title or "TITLE",
    })
    return self
  end

  function self.build()
    local result = { title = title or "TITLE", url = url or "URL" }
    if #reviewNodes > 0 then
      result["reviews"] = { nodes = reviewNodes }
    end
    if #commitStatusContexts > 0 then
      result["commits"] = {
        nodes = {
          {
            commit = {
              status = {
                contexts = commitStatusContexts
              }
            }
          }
        }
      }
    end
    return result
  end

  return self
end

local function inspect(table, indent)
  local result = indent .. "{\n"
  for k,v in pairs(table) do
    local representation = v
    if type(v) == "table" then
      representation = inspect(v, indent .. "  "):gsub("^%s*(.-)%s*$", "%1")
    end
    result = result .. string.format("%s%s = %s\n", indent .. "  ", k, representation)
  end
  result = result .. indent .. "}\n"
  return result
end

local function p(table)
  print(inspect(table, ""))
  return table
end

print("empty json")
prs:summary({}).
  accept(testVisitor()).
  assertSummary(1, 0)

print("no prs")
prs:summary(response().build()).
  accept(testVisitor()).
  assertSummary(1, 0)

print("1 pr - count")
prs:summary(response().with(pr()).build()).
  accept(testVisitor()).
  assertSummary(1, 1)

print("1 pr - title & url")
prs:summary(response().with(pr("foo", "URL")).build()).
  accept(testVisitor()).
  assertPr(1, "foo", "URL")

print("1 pr - 1 review")
prs:summary(response().
  with(pr().review("APPROVED", "Bob", "URL", "2023-09-19T09:01:02Z")).
  build()).
  accept(testVisitor()).
  assertReview(1, "Bob", "URL", os.time({
    year = 2023,
    month = 9,
    day = 19,
    hour = 9,
    min = 1,
    sec = 2,
  }) - 18000)

print("1 pr - 2 reviews, take latest by author")
prs:summary(response().
  with(pr().review("CHANGES_REQUESTED", "Bob").review("APPROVED", "Bob")).
  build()).
  accept(testVisitor()).
  assertReview(1, "Bob", "URL")

print("1 pr - 1 review, exclude by author")
prs:summary(response().
  with(pr().review("COMMENTED", "Me")).
  build(), "Me").
  accept(testVisitor()).
  assertReviews(0)

print("1 pr - 1 check")
prs:summary(response().
  with(pr().check("SUCCESS", "foo", "URL")).
  build()).
  accept(testVisitor()).
  assertCheck(1, "foo", "URL")

print("2 prs - state rollup")
prs:summary(response().
  with(pr("T1", "U1").review("COMMENTED").check("SUCCESS")).
  with(pr("T2", "U2").review("CHANGES_REQUESTED")).
  build()).
  accept(testVisitor()).
  assertSummary(3, 2).
  assertPr(2, "T1", "U1").
  assertPr(3, "T2", "U2")
