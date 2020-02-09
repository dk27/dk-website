app = {}

app.display_about = function() {
    $('.about').on('click', function(){
        $('.js-main').hide();
        $('.js-contact').hide();
        $('.js-about').show();
    });
}

app.display_contact = function() {
    $('.contact').on('click', function(){
        $('.js-main').hide();
        $('.js-about').hide();
        $('.js-contact').show();
    });
}

app.init = function(){
    app.display_about();
    app.display_contact();
}
$(function() {
    app.init();
});