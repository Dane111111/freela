
//var BaseUrl = "http://192.168.20.53:8080";
//var BaseUrl = "http://59.108.126.36:8585";
//var BaseUrl = "http://59.108.126.36:8888";
var BaseUrl  ="";   //freela




$(document).ready(function(){
//window.details.cetInfo();
//window.details.getreplay();
//打开评论内容
  $("#replay_button").click(function(){
FLMethodXQModel.alertPopViewInhtmlReJudge();
  });

});
function flReJudgegetInfoInHTML(name1,tupian2,time3,content4,hehe){
     
    $("#cetname").html(name1);
    $("#cettime").html(hehe);
    $("#cetcontent").html(time3);
    $("#head-img").attr("src",BaseUrl+tupian2);
}
/*
 avatar = "/resources/static/user/cut_xpuser1463737537347.png";
 businessId = 44;
 commentId = 251;
 commentType = 0;
 commentcode = 0;
 content = d;
 createTime = "2016-05-24 13:49:20";
 isFlush = 0;
 nickname = allen;
 parentId = 0;
 userId = 100010;
 userType = person;
 
 */

function xjRejudgeListInfoPage(xjRejudgeListInfo) {
    alert('ss');
    $("#cetname").html(xjRejudgeListInfo.nickname);
    $("#cettime").html(xjRejudgeListInfo.createTime);
    $("#cetcontent").html(xjRejudgeListInfo.content);
    $("#head-img").attr("src",BaseUrl+xjRejudgeListInfo.avatar);
}


function replayList(relayJson){
    var layout=""
    for(var i=0;i<relayJson.length;i++){
        layout+='<div class="user-pinglun_a" >'
        layout+='<img src="'+relayJson[i].avatar+'" width="46" height="46" >'
        layout+='<div class="head-name">'
        layout+='<p class="pr-spot-desc2 free_dis4" style="font-size:10px;">'+relayJson[i].nickname+'<span>'+relayJson[i].createTime+'</span></p>'
        layout+='<p class="pr-spot-desc2 free_dis4" style="font-size:12px;">'+relayJson[i].content+'</p>'
        layout+='</div>'
        layout+='</div>'
    }
    $("#relayId").html(layout);
    
}