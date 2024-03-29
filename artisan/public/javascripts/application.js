// チャットデータ更新
function update_chats(path, data) {
  if (data == null) data = {};
  data["update"] = true;
  $("#update_load").html("updating...");
  $("#update_load").load(path, data);
}
function update_wayback_chats(path) {
  var data = {"wayback_date":$("#wayback_date").val()};
  update_chats(path, data);
}
// テーブルソートとチェックボックスをセットアップ
function set_tablesorter() {
  $(document).ready(function(){
    $("#table").tablesorter();
    $(".check").each(function(){
      if ($(this).attr('checked')) {
        $(this).parent().parent().addClass('odd');
      } else {
        $(this).parent().parent().removeClass('odd');
      }
    });
    $(".check").click(function(){
      if ($(this).attr('checked')) {
        $(this).parent().parent().addClass('odd');
      } else {
        $(this).parent().parent().removeClass('odd');
      }
    });
  });
}
// コメントアートを投稿する
function post_comments(art_id) {
  var base_url = 'http://www.nicovideo.jp/watch/';
  var post_vid = $("#post_vid").val().replace(base_url, '');
  var post_vpos = $("#post_vpos").val();
  $("#post_status").show().html('<a href="'+base_url+post_vid+'">loading...</a>');
  $.ajax({
    url: '/arts/'+art_id+'/nicopost',
    data: { vid:post_vid, vpos:post_vpos },
    type: 'POST',
    timeout: 300000,
    success: function(result) {
      $("#post_status").html(result);
    }
  });
}
function set_wayback() {
  $("#wayback_date").datepicker();
}
