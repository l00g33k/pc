# fetch /ls.htm?path=$ctrl->{'FORM'}->{'arg1'} every second 
# and update displaying using javascript

$htmlframe = <<HTMLBLK;
<script Language="JavaScript">
var timerID = null;
var timerRunning = false;
var startsec;
//var messageurl = 
//'/do.htm?do=Do+m%CC%B2ore&path=%2Fsdcard%2Fl00httpd%2Fl00_js_update.pl&refresh=&bare=on&arg1=auto&arg2=sun&arg3=';
//'/do.htm?do=Do+m%CC%B2ore&path=/sdcard/l00httpd/l00_js_update.pl&refresh=&bare=on&arg2=sun&arg3=&arg1=/sdcard/x/x.txt';

function stopclock (){
    if(timerRunning)
        clearTimeout(timerID);
    timerRunning = false;
}

function startclock () {
    // Make sure the clock is stopped
    stopclock();
    var currentTime = new Date ( );

    var currentHours = currentTime.getHours ( );
    var currentMinutes = currentTime.getMinutes ( );
    var currentSeconds = currentTime.getSeconds ( );
    startsec = currentSeconds + currentMinutes * 60 + currentHours * 3600;

    updateClock();
}

function image() {
    var img = document.createElement("IMG");
    img.src = "/ls.htm/0424.jpg?path=C%3a%2fg%2fxf%2f0424.jpg";
    document.getElementById('imageDiv').appendChild(img);
}

function updateClock () {
    var currentTime = new Date ( );

    var currentHours = currentTime.getHours ( );
    var currentMinutes = currentTime.getMinutes ( );
    var currentSeconds = currentTime.getSeconds ( );

    // Pad the minutes and seconds with leading zeros, if required
    currentHours   = ( currentHours < 10 ? "0" : "" ) + currentHours;
    currentMinutes = ( currentMinutes < 10 ? "0" : "" ) + currentMinutes;
    currentSeconds = ( currentSeconds < 10 ? "0" : "" ) + currentSeconds;
    // Compose the string for display
    var currentTimeString = currentHours + ":" + currentMinutes + ":" + currentSeconds;
    // Update the time display
    document.getElementById("clock").firstChild.nodeValue = currentTimeString;

    if (messageurl !== undefined) {
        fetch(messageurl)
            .then(resp => resp.text())
            .then(message => {
                document.getElementById("message").innerHTML = message;
//image();

            });
    }

    timerID = setTimeout("updateClock()", 1999);
    timerRunning = true;
}



</script>

<p>
<div id="wholepage" style="text-align: center;">
<table>
<tr><td>
    <table border=1 cellpadding=10 cellspacing=1>
        <tr><td>
            <span id="clock">00:00:00</span>
        </td><td>
            <form name="clock" onSubmit="0">
                <input type="button" name="s&#818;tart" value="Run"  onClick="startclock()" accesskey="s">
                <input type="button" name="st&#818;op"  value="Stop" onClick="stopclock()" accesskey="t">
            </form>
        </td></tr>
    </table>
</td></tr>
</table>
</div>
<p>
<div>
    <span id="message">(Set target file in Arg1, click Run)</span>
</div>
<div id="imageDiv"></div>
<br>
<p>
<p>
<p>
<p>
<p>
<p>
HTMLBLK



if (defined($ctrl->{'FORM'}->{'js_update'})) {
    $html = '(no text 2)';
    if (&l00httpd::l00freadOpen($ctrl, $ctrl->{'FORM'}->{'arg1'})) {
        $html = &l00httpd::l00freadAll($ctrl);
        $html = &l00wikihtml::wikihtml ($ctrl, '', $html, 0, '');
        $html = "<script>\n".
                "console.log('101 messageurl=',messageurl);\n".
                "</script>".
                "<strong>Wikitized Arg1: $ctrl->{'FORM'}->{'arg1'}</strong>:<p>".
                "$html";
    }
    print $sock "HTTP/1.0 200 OK\x0D\x0A\x0D\x0A$html";
} elsif (defined($ctrl->{'FORM'}->{'arg1'})) {
    $html = '(no text)';
    if (&l00httpd::l00freadOpen($ctrl, $ctrl->{'FORM'}->{'arg1'})) {
        $html = "<script>messageurl = '/ls.htm?path=$ctrl->{'FORM'}->{'arg1'}';\n".
                "console.log('114 messageurl=',messageurl);\n".
                "</script>".
                "<strong>Wikitized Arg1: $ctrl->{'FORM'}->{'arg1'}</strong>:<p>".
                "$htmlframe";
    }
    print $sock "HTTP/1.0 200 OK\x0D\x0A\x0D\x0A$html";
} else {
    print $sock "<p>$htmlframe";
}


1;
