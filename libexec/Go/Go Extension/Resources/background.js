// https://github.com/trotto/browser-extension/blob/master/src/background/background.js
class Background {
  constructor() {
    this.api = browser;
  }

  run() {
    console.log("Running!");
    this.registerListeners();
  }

  registerListeners() {
    this.api.webRequest.onBeforeRequest.addListener(
      this.rewriteGoRequests.bind(this),
      { urls: ["<all_urls>"] },
      []
    );
  }

  // https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions/API/webRequest/onBeforeRequest#details
  rewriteGoRequests(details) {
    console.log("Yay!");
    console.log(details);
    const redirectUrl = "https://go.crdb.dev/wiki";
    // It seems that, even with a Promise here, Safari no likey.
    // I may need to switch to a native extension, as outlined here:
    // https://stackoverflow.com/questions/40959635/safari-extension-and-chrome-webrequest-onbeforerequest-addlistener
    return new Promise((resolve, reject) => {
      console.log("Resolving?");
      resolve({ redirectUrl });
    });
  }
}

new Background().run();
