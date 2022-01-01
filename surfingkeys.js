settings.hintAlign = "left";
//Hints.characters = 'yuiophjklnm'; // for right hand
api.Hints.characters = 'fjdkrueisl'; // Home row without pinky

api.cmap('<Ctrl-j>', '<Tab>');
api.cmap('<Ctrl-k>', '<Shift-Tab>');

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
api.unmap(";m")
api.unmap(";m")


//
api.unmap("e")

api.unmap("C")
api.unmap("<Ctrl-i>")

api.mapkey('ye', 'Copy src URL of an image', function() {
    Hints.create('img[src]',(element, event) =>  {
        api.Clipboard.write(element.src);
    });
});

api.mapkey('yme', 'Copy multiple link URLs to the clipboard', function() {
    let linksToYank = [];
    Hints.create('img[src]', function(element) {
        linksToYank.push(element.src);
        api.Clipboard.write(linksToYank.join('\n'));
    }, {multipleHits: true});
});

api.mapkey(';n', 'Go to next episode',
       function next_episode(){
           base_url = window.location.href
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
    const messages = [...mouse, ...tabs].map(row => ( {
            binding: row[0].slice(1, -1),
            description: row[1]
        }))
        .map(obj => `${obj.binding}\t\t\t\t${obj.description}`)

    Front.showPopup(`<h1>${messages.join('<br>')} </h1>`);
}

api.mapkey(";?", "Show currently training keybindings", showCurrentTrainingBindings);

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
