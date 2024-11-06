window.addEventListener('message', function(e) {
    if (e.data.action == 'show') {
        const fallingTreeMusic = new Audio(`${event.data.data}.mp3`); 
        fallingTreeMusic.play(); 
    }
});
