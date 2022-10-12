local logger = hs.logger.new("PRs", "debug")

local function StateInterpreter()
  local self = {}

  local result = 1

  function self.pr(state)
    -- no-op?
  end

  function self.review(state)
    result = math.max(result, state)
  end

  function self.check(state)
    -- Hmm, state can be nil?
    if state then
      result = math.max(result, state)
    end
  end

  function self.result()
    return result
  end

  return self
end

local function Summary(prs)
  local self = {}

  local function state()
    return prs.accept(StateInterpreter()).result()
  end

  function self.accept(visitor)
    visitor.summary(state(), prs.size())
    prs.accept(visitor)
    return visitor
  end

  return self
end

local function PullRequest(title, url, reviews, checks)
  local self = {}

  local function state()
    local interpreter = StateInterpreter()
    reviews.accept(interpreter)
    checks.accept(interpreter)
    return interpreter.result()
  end

  function self.accept(visitor)
    visitor.pr(state(), title, url)
    reviews.accept(visitor)
    checks.accept(visitor)
    return visitor
  end

  return self
end


local reviewCodes = {
  PENDING = 2,
  COMMENTED = 2,
  APPROVED = 1,
  CHANGES_REQUESTED = 3,
  DISMISSED = 2,
}

local function Review(name, state, url)
  local self = {}

  function self.accept(visitor)
    visitor.review(reviewCodes[state], name, url)
    return visitor
  end

  function self.author()
    return name
  end

  return self
end

local checkCodes = {
  FAILURE = 3,
  PENDING = 2,
  SUCCESS = 1,
}

local function Check(title, state, url)
  local self = {}

  function self.accept(visitor)
    -- Hmm, some nil state is coming through?
    if not checkCodes[state] then
      logger.error("no check code for state", state)
    end
    visitor.check(checkCodes[state], title, url)
    return visitor
  end

  return self
end

local function Collection(things)
  local self = {}

  function self.accept(visitor)
    for _, thing in ipairs(things) do
      thing.accept(visitor)
    end
    return visitor
  end

  function self.size()
    return #things
  end

  return self
end


local obj = {}

local function iconFromText(text, hex)
  return hs.canvas.new({h=16,w=16}):appendElements({
    text = hs.styledtext.new(text, { color = { hex = hex }, font = hs.styledtext.defaultFonts.menuBar }), type = "text"
  }):imageFromCanvas()
end

local stateIcons = {}

function obj:init()
  stateIcons = {
    iconFromText("✓", "#1a7f37"),
    iconFromText("•", "#bf8700"),
    iconFromText("𐄂", "#cf222e"),
  }
end

local function path(obj, keys)
  local result = obj or {}
  for _, key in ipairs(keys) do -- how do varargs even?
    result = result[key] or {}
  end
  return result
end

function obj:summary(nodes, author)
  local prs = {}

  for _, node in ipairs(nodes) do
    local reviews = {}
    local checks = {}

    local latestReviews = {}

    for _, review in ipairs(path(node, { "reviews", "nodes" })) do
      local reviewer = path(review, { "author" })
      local name = reviewer["name"] or reviewer["login"]
      if name ~= author then
        latestReviews[name] = Review(name, review.state, review.url)
      end
    end

    for _, review in pairs(latestReviews) do
      table.insert(reviews, review)
    end

    for _, check in ipairs(path(node, { "commits", "nodes", 1, "commit", "status", "contexts" })) do
      table.insert(checks, Check(
        check.context,
        check.state,
        check.targetUrl
      ))
    end

    table.insert(prs, PullRequest(
      node.title,
      node.url,
      Collection(reviews),
      Collection(checks)
    ))
  end

  return Summary(Collection(prs))
end

function zeroPrsMenuBuilder(menubar)
  local self = {}

  function self.summary(state, count)
    menubar:setIcon(nil)
    menubar:setTitle("")
    menubar:setMenu({})
  end

  function self.pr(state, title, url)
  end

  function self.review(state, name, url)
  end

  function self.check(state, title, url)
  end

  function self.render()
    menubar:removeFromMenuBar()
  end

  return self
end

function singlePrMenuBuilder(menubar)
  local self = {}
  local menu = {}

  local hasReviews = false
  local hasChecks = false

  function self.summary(state, count)
    -- no-op
  end

  function self.pr(state, title, url)
    menubar:setIcon(stateIcons[state], false)
    menubar:setTitle(title)
    table.insert(menu, {
      title = "Open in Github",
      fn = function() hs.urlevent.openURL(url) end,
    })
  end

  function self.review(state, name, url)
    if not hasReviews then
      hasReviews = true
      table.insert(menu, { title = "-" })
    end
    table.insert(menu, {
      image = stateIcons[state],
      title = name,
      fn = function() hs.urlevent.openURL(url) end,
    })
  end

  function self.check(state, title, url)
    if not hasChecks then
      hasChecks = true
      table.insert(menu, { title = "-" })
    end
    table.insert(menu, {
      image = stateIcons[state],
      title = title,
      fn = function() hs.urlevent.openURL(url) end,
    })
  end

  function self.render()
    menubar:setMenu(menu)
    menubar:returnToMenuBar()
  end

  return self
end

function multiplePrsMenuBuilder(menubar)
  local self = {}
  local menu = {}
  local hasPrs = false

  function self.summary(state, count)
    menubar:setIcon(stateIcons[state], false)
    menubar:setTitle(string.format("%d Pull Requests", count))
  end

  function self.pr(state, title, url)
    if hasPrs then
      table.insert(menu, { title = "-" })
    else
      hasPrs = true
    end
    table.insert(menu, {
      title = title,
      fn = function() hs.urlevent.openURL(url) end,
    })
  end

  function self.review(state, name, url)
    table.insert(menu, {
      image = stateIcons[state],
      title = name,
      indent = 1,
      fn = function() hs.urlevent.openURL(url) end,
    })
  end

  function self.check(state, title, url)
    table.insert(menu, {
      image = stateIcons[state],
      title = title,
      indent = 1,
      fn = function() hs.urlevent.openURL(url) end,
    })
  end

  function self.render()
    menubar:setMenu(menu)
    menubar:returnToMenuBar()
  end

  return self
end

function obj:menuBuilder(menubar)
  local self = {}
  local strategy = nil

  function self.summary(state, count)
    if count == 0 then
      strategy = zeroPrsMenuBuilder(menubar)
    elseif count == 1 then
      strategy = singlePrMenuBuilder(menubar)
    else
      strategy = multiplePrsMenuBuilder(menubar)
    end

    strategy.summary(state, count)
  end

  function self.pr(state, title, url)
    strategy.pr(state, title, url)
  end

  function self.review(state, name, url)
    strategy.review(state, name, url)
  end

  function self.check(state, title, url)
    strategy.check(state, title, url)
  end

  function self.render()
    strategy.render()
  end

  return self
end

return obj
