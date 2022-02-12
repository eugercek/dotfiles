settings.hintAlign = "left";
//Hints.characters = 'yuiophjklnm'; // for right hand
api.Hints.characters = "fjdkrueisl"; // Home row without pinky

api.cmap("<Ctrl-j>", "<Tab>");
api.cmap("<Ctrl-k>", "<Shift-Tab>");

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
  ".*anime.*",
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

let videoBlockedKeys = new RegExp(blockSites.join("|"), "i");
let youtubeBlockedKeys = new RegExp(blockSites.join("|"), "i");

videoKeys.forEach((i) => api.map(alt_key(i), i, videoBlockedKeys));
youtubeKeys.forEach((i) => api.map(alt_key(i), i, youtubeBlockedKeys));

videoKeys.forEach((i) => api.unmap(i, videoBlockedKeys));
youtubeKeys.forEach((i) => api.unmap(i, youtubeBlockedKeys));

key("J", "E");
key("K", "R");
key("H", "S");
key(";o", "<Ctrl-6>");
key("L", "D");
key("F", "gf");

api.unmap("<Ctrl-j>");
api.unmap("<Ctrl-h>");
api.unmap(";m");
api.unmap(";m");

//
api.unmap("e");

api.unmap("C");
api.unmap("<Ctrl-i>");

api.mapkey("ye", "Copy src URL of an image", function () {
  Hints.create("img[src]", (element, event) => {
    api.Clipboard.write(element.src);
  });
});

api.mapkey("yme", "Copy multiple link URLs to the clipboard", function () {
  let linksToYank = [];
  Hints.create(
    "img[src]",
    function (element) {
      linksToYank.push(element.src);
      api.Clipboard.write(linksToYank.join("\n"));
    },
    { multipleHits: true }
  );
});

api.mapkey(";n", "Go to next episode", function next_episode() {
  base_url = window.location.href;
  ep_no = base_url.match(/(\d+)(?!.*\d)/)[0];
  new_ep = parseInt(ep_no, 10) + 1;
  n = base_url.lastIndexOf(ep_no);
  new_url = base_url.slice(0, n) + base_url.slice(n).replace(ep_no, new_ep);
  window.location = new_url;
});

api.mapkey(";c", "Copy title and url for org mode", () => {
  let url = document.URL;
  let title = document.title;
  api.Clipboard.write(`[[${url}][${title}]]`);
});

const showCurrentTrainingBindings = () => {
  const messages = [...mouse, ...tabs]
    .map((row) => ({
      binding: row[0].slice(1, -1),
      description: row[1],
    }))
    .map((obj) => `${obj.binding}\t\t\t\t${obj.description}`);

  Front.showPopup(`<h1>${messages.join("<br>")} </h1>`);
};

api.mapkey(
  ";?",
  "Show currently training keybindings",
  showCurrentTrainingBindings
);

api.mapkey(
  "ec",
  "GitHub Clone Repo (HTTPS)",
  () => {
    const gitURL = `${document.URL}.git`;
    const terminalCommand = `git clone ${gitURL}`;
    api.Clipboard.write(terminalCommand);
  },
  { domain: /github.com/i }
);

solarizedDark = `
.sk_theme {
	background: #100a14dd;
	color: #4f97d7;
}
.sk_theme tbody {
	color: #292d;
}
.sk_theme input {
	color: #d9dce0;
}
.sk_theme .url {
	color: #2d9574;
}
.sk_theme .annotation {
	color: #a31db1;
}
.sk_theme .omnibar_highlight {
	color: #333;
	background: #ffff00aa;
}
.sk_theme #sk_omnibarSearchResult ul li:nth-child(odd) {
	background: #5d4d7a55;
}
.sk_theme #sk_omnibarSearchResult ul li.focused {
	background: #5d4d7aaa;
}
.sk_theme #sk_omnibarSearchResult .omnibar_folder {
	color: #a31db1;
}
`;

zenbonse = `
.sk_theme {
  font-family: SauceCodePro Nerd Font, Consolas, Menlo, monospace;
  font-size: 10pt;
  background: #f0edec;
  color: #2c363c;
}
.sk_theme tbody {
  color: #f0edec;
}
.sk_theme input {
  color: #2c363c;
}
.sk_theme .url {
  color: #1d5573;
}
.sk_theme .annotation {
  color: #2c363c;
}
.sk_theme .omnibar_highlight {
  color: #88507d;
}
.sk_theme #sk_omnibarSearchResult ul li:nth-child(odd) {
  background: #f0edec;
}
.sk_theme #sk_omnibarSearchResult ul li.focused {
  background: #cbd9e3;
}
#sk_status,
#sk_find {
  font-size: 10pt;
}
`;

settings.theme = `
  @media (prefers-color-scheme: dark) {
  ${solarizedDark}
}
  @media (prefers-color-scheme: light) {
  ${zenbonse}
}
}
`;
