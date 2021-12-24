settings.hintAlign = "left";
//Hints.characters = 'yuiophjklnm'; // for right hand
Hints.characters = 'fjdkrueisl'; // Home row without pinky

cmap('<Ctrl-j>', '<Tab>');
cmap('<Ctrl-k>', '<Shift-Tab>');

settings.hintAlign = "left";
//Hints.characters = 'yuiophjklnm'; // for right hand
Hints.characters = "fjdkrueisl"; // Home row without pinky

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
    map(newKey, oldKey, domain);
  }
  unmap(oldKey);
};

let videoBlockedKeys = new RegExp(blockSites.join("|"), "i");
let youtubeBlockedKeys = new RegExp(blockSites.join("|"), "i");

videoKeys.forEach((i) => map(alt_key(i), i, videoBlockedKeys));
youtubeKeys.forEach((i) => map(alt_key(i), i, youtubeBlockedKeys));

videoKeys.forEach((i) => unmap(i, videoBlockedKeys));
youtubeKeys.forEach((i) => unmap(i, youtubeBlockedKeys));

key("J", "E");
key("K", "R");
key("H", "S");
key(";o", "<Ctrl-6>");
key("L", "D");
key("F", "gf");

unmap("<Ctrl-j>");
unmap("<Ctrl-h>");
unmap(";m")

unmap("C")
unmap("<Ctrl-i>")

mapkey('ye', 'Copy src URL of an image', function() {
    Hints.create('img[src]',(element, event) =>  {
        Clipboard.write(element.src);
    });
});

mapkey('yme', 'Copy multiple link URLs to the clipboard', function() {
    let linksToYank = [];
    Hints.create('img[src]', function(element) {
        linksToYank.push(element.src);
        Clipboard.write(linksToYank.join('\n'));
    }, {multipleHits: true});
});

mapkey(';n', 'Go to next episode',
       function next_episode(){
           base_url = window.location.href
           ep_no = base_url.match(/(\d+)(?!.*\d)/)[0];
           new_ep = parseInt(ep_no, 10) + 1;
           n = base_url.lastIndexOf(ep_no);
           new_url = base_url.slice(0, n) + base_url.slice(n).replace(ep_no, new_ep);
           window.location = new_url;
       });

mapkey(";c", "Copy title and url for org mode", () => {
  let url = document.URL;
  let title = document.title;
  Clipboard.write(`[[${url}][${title}]]`);
});

var mouse=[["=;fs=", "Display hints to focus scrollable elements"], ["=;di=", "Download image"], ["=af=", "Open a link in active new tab"], ["=O=", "Open detected links from text"], ["=q=", "Click on an Image or a button"]];
var tabs=[["=T=", "Choose a tab"], ["=zr=", "zoom reset"], ["=zi=", "zoom in"], ["=zo=", "zoom out"], ["=<Alt-p>=", "Pin current tab"], ["=<Alt-m>=", "Mute current tab"], ["=on=", "Open new tab (=<Control-t>=)"]];
const showCurrentTrainingBindings = () => {
    const messages = [...mouse, ...tabs].map(row => ( {
            binding: row[0].slice(1, -1),
            description: row[1]
        }))
        .map(obj => `${obj.binding}\t\t\t\t${obj.description}`)

    Front.showPopup(`<h1>${messages.join('<br>')} </h1>`);
}

mapkey(";?", "Show currently training keybindings", showCurrentTrainingBindings);
