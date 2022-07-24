
$(function() {
    window.addEventListener('message', function(OpenCarRadio) {
        switch (OpenCarRadio.data.action) {
            case 'enable':
                $('#open_radio').fadeIn();
                var url = $("#url").val()
                getNameFile(url)
                break;
            case 'loop':
                document.getElementById("loopinfo").innerHTML = "<i class='fa-solid fa-rotate'></i>"
                break
            case 'play':
                    document.getElementById("info").innerHTML = "<i class='fa-solid fa-play'>"
                break
            case 'pause':
                document.getElementById("info").innerHTML = "<i class='fa-solid fa-pause'>"
                break
            case 'noloop':
                document.getElementById("loopinfo").innerHTML = ""
                break
            case 'volumeinfo':
                document.getElementById("volumeinfo").innerHTML = OpenCarRadio.data.volume
                break
            case 'playend':
                document.getElementById("url").value = "";
                document.getElementById("loopinfo").innerHTML = ""
                document.getElementById("info").innerHTML = ""
                document.getElementById("volumeinfo").innerHTML = ""
                var url = $("#url").val()
                setTimeout(() => {getNameFile(url);}, 100);
                break
        }
    });

    $("#closeRadio").click(function () {
        $('#open_radio').fadeOut();
            $.post('http://fv_carradio/action', JSON.stringify({
            action: 'closeCarRadio'
            }));
    })
    document.addEventListener('keyup', (e) => {
        if(e.key == 'Escape') {
            $('#open_radio').fadeOut();
                $.post('http://fv_carradio/action', JSON.stringify({
                action: 'closeCarRadio'
                }));
        }
    });
    $("#play").click(function () {
        var url = $("#url").val()
        if (url !== "" && url.substring(0,7) === 'http://' || url.substring(0,8) === 'https://') {
            $.post('http://fv_carradio/action', JSON.stringify({
            url: url,
            action: 'playMusic'
            }));
            getNameFile(url);
        }else{
            $.post('http://fv_carradio/action', JSON.stringify({
            action: 'errorPlay'
            }));
        }
    })
    $("#destroy").click(function () {
        $.post('http://fv_carradio/action', JSON.stringify({
            action: 'destroyMusic'
            }));
    })
    $("#loop").click(function () {
        $.post('http://fv_carradio/action', JSON.stringify({
            action: 'loopMusic'
            }));
    })
    $("#volumeup").click(function () {
        $.post('http://fv_carradio/action', JSON.stringify({
            action: 'volumeUp'
            }));
    })
    $("#volumedown").click(function () {
        $.post('http://fv_carradio/action', JSON.stringify({
            action: 'volumeDown'
            }));
    })

    var vidname = "Name not Found";

    function getNameFile(url) {
        if (url == "") {
            vidname = "Nothing...";
            document.getElementById("soundname").innerHTML = "<b>Playing:</b><br><marquee direction = 'right'> "+ vidname + "</marquee>"
        } else {
            $.getJSON('https://noembed.com/embed?url=', {format: 'json', url: url}, function (data) {
                vidname = data.title;
                whenDone(url);
            });
        }
    }

    const capitalize = (s) => {
        if (typeof s !== 'string') return ''
        return s.charAt(0).toUpperCase() + s.slice(1)
    }

    function whenDone(url) {
        if (vidname == undefined) {
            vidname = capitalize(GetFilename(url));
            if (vidname == "") {
                vidname = "Name not Found";
            }
        }
        document.getElementById("soundname").innerHTML = "<b>Playing:</b><br><marquee direction = 'right'> "+ vidname + "</marquee>"
    }

    function GetFilename(url)
    {
    if (url)
    {
        var m = url.toString().match(/.*\/(.+?)\./);
        if (m && m.length > 1)
        {
            return m[1];
        }
    }
    return "";
    }

    const d = document.getElementsByClassName("radio");

    for (let i = 0; i < d.length; i++) {
    d[i].style.position = "relative";
    }

    function filter(e) {
    let target = e.target;

    if (!target.classList.contains("radio")) {
        return;
    }

    target.moving = true;

    if (e.clientX) {
        target.oldX = e.clientX; 
        target.oldY = e.clientY;
    } else {
        target.oldX = e.touches[0].clientX; 
        target.oldY = e.touches[0].clientY;
    }

    target.oldLeft = window.getComputedStyle(target).getPropertyValue('left').split('px')[0] * 1;
    target.oldTop = window.getComputedStyle(target).getPropertyValue('top').split('px')[0] * 1;

    document.onmousemove = dr;
    document.ontouchmove = dr;

    function dr(event) {
        event.preventDefault();

        if (!target.moving) {
        return;
        }
        if (event.clientX) {
        target.distX = event.clientX - target.oldX;
        target.distY = event.clientY - target.oldY;
        } else {
        target.distX = event.touches[0].clientX - target.oldX;
        target.distY = event.touches[0].clientY - target.oldY;
        }

        target.style.left = target.oldLeft + target.distX + "px";
        target.style.top = target.oldTop + target.distY + "px";
    }

    function endDrag() {
        target.moving = false;
    }
    target.onmouseup = endDrag;
    target.ontouchend = endDrag;
    }
    document.onmousedown = filter;
    document.ontouchstart = filter;
});
