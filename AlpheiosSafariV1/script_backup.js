 document.addEventListener("DOMContentLoaded", function(event) {
    safari.extension.dispatchMessage("SayHello");
                          
    document.body.addEventListener('dblclick', function (event) {
        console.info('there was dblclick done');
    })
});

safari.self.addEventListener("message", messageHandler);

function messageHandler(event) {
    if (event.name === "helloInfoMessage") {
        console.info('Hello, I am here!');
    }
    if (event.name === "toolbarItemClicked") {
        console.info('Toolbar was clicked!');
    }
}

