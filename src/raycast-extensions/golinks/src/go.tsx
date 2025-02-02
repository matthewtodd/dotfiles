import { Action, ActionPanel, Icon, List } from "@raycast/api";
import { getFavicon, useFetch } from "@raycast/utils";

type GoLink = {
  Short: string;
  Long: string;
  Created: string;
  LastEdit: string;
  Owner: string;
};

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

  return (
    <List isLoading={isLoading}>
      {(data as GoLink[]).map((d) => (
        <List.Item
          key={d.Short}
          title={d.Short}
          subtitle={d.Long}
          icon={getFavicon(d.Long)}
          accessories={[{ icon: Icon.Person, text: d.Owner }]}
          actions={
            <ActionPanel>
              <Action.OpenInBrowser url={"http://go/" + d.Short} />
              <Action.OpenInBrowser url={"http://go/.detail/" + d.Short} title="Open Details in Browser" />
            </ActionPanel>
          }
        />
      ))}
    </List>
  );
}
