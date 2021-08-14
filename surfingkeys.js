settings.hintAlign = "left";
//Hints.characters = 'yuiophjklnm'; // for right hand
Hints.characters = 'fjdkrueisl'; // Home row without pinky

cmap('<Ctrl-j>', '<Tab>');
cmap('<Ctrl-k>', '<Shift-Tab>');

function alt_key(default_key){
    return ',' + default_key;
}

var vsc_keys = ['v', 's', 'd', 'h', 'l', 'r']; //Video Speed Controller Keys
var youtube_keys = ['i', 'f', 'c', '0'];
var block_sites = ["netflix.com", "youtube.com", ".*dizi.*", ".*film.*" , ".*anime.*", "udemy.com"];

var block_for_vsc= new RegExp(block_sites.join("|"), "i");
var block_for_youtube= new RegExp(block_sites.join("|"), "i");


//Add Alternatives
vsc_keys.forEach(item => map(alt_key(item), item, block_for_vsc));
youtube_keys.forEach(item => map(alt_key(item), item));

//Remove Keys
vsc_keys.forEach(item => unmap(item, block_for_vsc));
youtube_keys.forEach(item => unmap(item, block_for_youtube));

//Normal Tabs
map('J', 'E');
map('K', 'R');
var j_k_character=0;

map('H', 'S');
map(';o', '<Ctrl-6>');
map('L', 'D');
map('F', 'gf');

unmap('<Ctrl-j>');
unmap('<Ctrl-h>');
unmap('E');
unmap('R');
unmap('S');
unmap('<Ctrl-6>');
unmap('D');
unmap('gf');

mapkey('ye', 'Copy src URL of an image', function() {
    Hints.create('img[src]', function(element, event) {
        Clipboard.write(element.src);
    });
});

mapkey('yme', 'Copy multiple link URLs to the clipboard', function() {
    var linksToYank = [];
    Hints.create('img[src]', function(element) {
        linksToYank.push(element.src);
        Clipboard.write(linksToYank.join('\n'));
    }, {multipleHits: true});
});

mapkey(';n', 'Go to next episode',
       function next_episode(){
           base_url = window.location.href
           ep_no = base_url.match(/(\d+)(?!.*\d)/)[0]
           new_ep = parseInt(ep_no, 10) + 1;
           n = base_url.lastIndexOf(ep_no);
           new_url = base_url.slice(0, n) + base_url.slice(n).replace(ep_no, new_ep);
           window.location = new_url;
       });
