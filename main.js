app = {}

app.show_more = function(){
    $('.js-main1').show();
    $('.btn-div').hide();
}

$(function() {
    $('.js-main1').hide();
    $('.see-more-btn').click(function(){
        app.show_more();
    })
});