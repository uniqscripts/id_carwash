$(function () {
    function display(bool) {
        if (bool) {
            $("html").show();
  
        } else {
            $("html").hide();
        }
    }

    $("#businessowner").hide();

    display(false)

    window.addEventListener('message', function(event) {
        var item = event.data;

        if (item.type === "show") {

            if (item.status == true) {
                $("html").fadeIn();
                display(true)
            } else {
                $("html").fadeOut("slow");
                display(false)
            }
        }

        if (item.type === "showowner") {

            if (item.status == true) {
                $("#businessowner").fadeIn();
                display(true)
            }
        }
    })

    window.addEventListener('message', function (event) {

        try {
            switch(event.data.action) {
                // Car Wash Price (config.lua)
                case 'businesscash':
                    if (event.data.value != null) businesscash.innerHTML = event.data.value.toLocaleString('en-US') + '$';
                break;

                // Money in the business
                case 'businessmoney':
                    if (event.data.value != null) businessmoney.innerHTML = event.data.value.toLocaleString('en-US') + '$';
                break;

                // Business Owner Name
                case 'ownername':
                    if (event.data.value != null) ownername.innerHTML = event.data.value;
                break;
            }
        }

    catch(err) {}
    });
    
    document.onkeyup = function (data) {
        if (data.which == 27) {
            $("html").fadeOut("slow");
            $.post('https://iCarWash/close', JSON.stringify({}));
            return
        }
    };

    $("#button").click(function () {
        $.post('https://iCarWash/wash', JSON.stringify({}));
        return
    })

    $("#buttonowner").click(function () {
        $.post('https://iCarWash/ownermenu', JSON.stringify({}));
        return
    })
})