import { Action, ActionPanel, Icon, List } from "@raycast/api";
import { getFavicon, useFetch } from "@raycast/utils";
import { useState } from "react";

type GoLink = {
  Short: string;
  Long: string;
  Created: string;
  LastEdit: string;
  Owner: string;
};

const favicon = (string: string) => {
  const match = string.match(/https?:\/\/.*?\//);

  if (match) {
    return getFavicon(match[0]);
  }
}


function Path({ golink }: { golink: GoLink }) {
  const [searchText, setSearchText] = useState("");

  return (
    <List filtering={false} searchBarPlaceholder={golink.Short} onSearchTextChange={setSearchText}>
      <List.Item
        title={golink.Short + "/" + searchText}
        subtitle={golink.Long}
        icon={favicon(golink.Long)}
        accessories={[{ icon: Icon.Person, text: golink.Owner }]}
        actions={
          <ActionPanel>
            <Action.OpenInBrowser url={"http://go/" + golink.Short + "/" + searchText} />
            <Action.OpenInBrowser url={"http://go/.detail/" + golink.Short} title="Open Details in Browser" />
            <Action.CopyToClipboard content={"http://go/" + golink.Short + "/" + searchText} shortcut={{ modifiers: ["cmd"], key: "c" }} />
          </ActionPanel>
        }
      />
    </List>
  );
}

function Item({ golink }: { golink: GoLink }) {
  const template = golink.Long.match(/{{/);

  return (
    <List.Item
      key={golink.Short}
      title={golink.Short}
      subtitle={golink.Long}
      icon={favicon(golink.Long)}
      accessories={[{ icon: Icon.Person, text: golink.Owner }]}
      actions={
        template ? (
          <ActionPanel>
            <Action.Push title="Append Path" target={<Path golink={golink} />} />
          </ActionPanel>
        ) : (
          <ActionPanel>
            <Action.OpenInBrowser url={"http://go/" + golink.Short} />
            <Action.OpenInBrowser url={"http://go/.detail/" + golink.Short} title="Open Details in Browser" />
            <Action.CopyToClipboard content={"http://go/" + golink.Short} shortcut={{ modifiers: ["cmd"], key: "c" }} />
          </ActionPanel>
        )
      }
    />
  )
}

export default function Command() {
  const { data, isLoading } = useFetch("http://go/.export", {
    initialData: [] as GoLink[],
    parseResponse: (response) => response.text(),
    mapResult: (text) => {
      return {
        data: text
          .split("\n")
          .filter((line) => line.trim().length > 0)
          .map((line) => JSON.parse(line) as GoLink),
      };
    },
    keepPreviousData: true,
  });


  // https://developers.raycast.com/
  return (
    <List isLoading={isLoading}>
      {(data as GoLink[]).map((golink) => (
        <Item golink={golink} />
      ))}
    </List>
  );
}
