settings.hintAlign = "left";
//Hints.characters = 'yuiophjklnm'; // for right hand
api.Hints.characters = "fjdkrueisl"; // Home row without pinky


let videoKeys = ["v", "s", "d", "h", "l", "r"]; //Video Speed Controller Keys
let youtubeKeys = ["i", "f", "c", "0"];
let blockSites = [
  "netflix.com",
  "youtube.com",
  ".*dizi.*",
  ".*film.*",
  "udemy.com",
];

const leaderKey = ",";

const alt_key = (key) => leaderKey + key;

// `map` handles bad domain
const key = (newKey, oldKey, domain) => {
  if (newKey) {
    api.map(newKey, oldKey, domain);
  }
  api.unmap(oldKey);
};

function swapKeys(key1, key2, mode = "map", mode_remove = "unmap") {
  api[mode]("temp", key1);
  api[mode](key1, key2);
  api[mode](key2, key1);
  api[mode_remove]("temp");
}

const blockedSites = new RegExp(blockSites.join("|"), "i");

[...videoKeys, ...youtubeKeys].forEach((i) => {
  api.map(alt_key(i), i, blockedSites);
  api.unmap(i, blockedSites);
});

key("J", "E");
key("K", "R");
key("H", "S");
key(";o", "<Ctrl-6>");
key("L", "D");
key("F", "gf");

api.unmap("<Ctrl-j>");
api.unmap("<Ctrl-h>");
api.unmap(";m");

// Mine!
swapKeys(";u", ";U");

swapKeys("P", "p");
api.vunmap("p");

api.mapkey("ye", "Copy src URL of an image", () => {
  api.Hints.create("img[src]", (element) => {
    api.Clipboard.write(element.src);
  });
});

api.mapkey("yme", "Copy multiple image URLs to the clipboard", () => {
  let linksToYank = [];
  api.Hints.create("img[src]", (element) => {
    linksToYank.push(element.src);
    api.Clipboard.write(linksToYank.join("\n"));
  }, { multipleHits: true });
});

// Old is gold
api.Hints.style(
  "padding: 1px; color:#efe1eb; background: none; background-color: #b16286; font-size: 14px;"
);

api.Hints.style(
  "div{color:#efe1eb; background: none; background-color: #a73a1e;} div.begin{color:#ea6962; font-size: 0.9em;}",
  "text"
);
