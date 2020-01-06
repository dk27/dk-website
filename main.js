app = {}

app.display_about = function() {
    $('.about').on('click', function(){
        $('.js-main').hide();
        $('.js-about').show();
    });
}

$(function() {
    app.display_about();
});