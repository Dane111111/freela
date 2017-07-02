$(document).ready(function(){
window.details.cetInfo();
window.details.getreplay();
//打开评论内容
  $("#replay_button").click(function(){
window.details.openreplay();
  });

});
//var BaseUrl="http://192.168.20.53:8080/";
//var BaseUrl="http://123.57.35.196:80";
//var BaseUrl="http://59.108.126.36:8585";
//var BaseUrl="http://192.168.20.79:8888"
//var BaseUrl="http://59.108.126.36:8888";
var BaseUrl="http://www.freela.com.cn";
function cetperinfo(name1,tupian2,time3,content4){
$("#cetname").html(name1);
$("#cettime").html(time3);
$("#cetcontent").html(content4);
$("#head-img").attr("src",BaseUrl+tupian2);
}

function replayList(relayJson){
var layout=""
     for(var i=0;i<relayJson.length;i++){
     layout+='<div class="user-pinglun_a" >'
     layout+='<img src="'+BaseUrl+relayJson[i].avatar+'" width="46" height="46" >'
     layout+='<div class="head-name">'
     layout+='<p class="pr-spot-desc2 free_dis4" style="font-size:10px;">'+relayJson[i].nickname+'<span>'+relayJson[i].createTime+'</span></p>'
     layout+='<p class="pr-spot-desc2 free_dis4" style="font-size:12px;">'+relayJson[i].content+'</p>'
     layout+='</div>'
     layout+='</div>'
            }
         $("#relayId").html(layout);

}

