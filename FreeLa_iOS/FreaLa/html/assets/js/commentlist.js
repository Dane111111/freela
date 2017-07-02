      /**
      *creatby zhangruofei
      *creatTime 2015-12-22
      * 评论js
      **/
 var BaseUrl="";
//       var BaseUrl="http://www.freela.com.cn";
       $(document).ready(function(){
        //获取评论内容
//        window.details.getComment();
                         
       });

//评论
function xjcommentInfo(commentJson,xjPLListIsFull){
    var pinglunJson=commentJson;
    var pinglunlayout="";
    $("#comment-zero").empty();
    if(pinglunJson!=null&&pinglunJson!=""){
        for(var i=0;i<pinglunJson.length;i++){
            pinglunlayout+='<div class="pr-container" style="border-bottom:1px solid #e3e3e3; padding-bottom: 0px;">'
            pinglunlayout+='<div class="user-pinglun"  onclick="commentIdd(\''+pinglunJson[i].nickname+'\',\''+pinglunJson[i].avatar+'\',\''+pinglunJson[i].createTime+'\',\''+pinglunJson[i].content+'\',\''+pinglunJson[i].commentId+'\')">'
            pinglunlayout+='<img src="'+BaseUrl+pinglunJson[i].avatar+'" width="56" height="56" >'
            pinglunlayout+='<div class="head-name">'
            pinglunlayout+='<div class="replay-btn3"></div>'
            pinglunlayout+='<p class="pr-spot-desc1 free_dis4">'+pinglunJson[i].nickname+'</p>'
            pinglunlayout+='<p class="pr-spot-desc3 free_dis4">'+pinglunJson[i].createTime+'</p>'
            pinglunlayout+='<p class="pr-spot-desc2 free_dis4" style="word-wrap:break-word;">'+pinglunJson[i].content+'</p>'
            pinglunlayout+='</div>'
            pinglunlayout+='</div>'
            pinglunlayout+='<div class="pinglun-container">'
            pinglunlayout+='</div>'
            pinglunlayout+='<div>'
            pinglunlayout+='</div>'
            pinglunlayout+='</div>'
        }
        if(xjPLListIsFull){
            pinglunlayout+='<div class="lookpinglun" style="border-top:1px solid #e3e3e3;">'
            pinglunlayout+='<a class="pr-spot-desc4 free_dis19 "style="display:block;width: 34%;margin: 0 auto;margin-top:10px;margin-bottom: 10px;">全部加载完毕</a>'
            pinglunlayout+='</div>'
        }else{
            pinglunlayout+='<div class="lookpinglun" style="border-top:1px solid #e3e3e3;">'
            pinglunlayout+='<a class="pr-spot-desc4 free_dis19 "style="display:block;width: 34%;margin: 0 auto;margin-top:10px;margin-bottom: 10px;" onclick="clickToCheackMore()">查看更多评论</a>'
            pinglunlayout+='</div>'
        }
        $("#comment-zero").html(pinglunlayout);
    }
    
}
     //回复评论
     function commentIdd(name,tupian,time,content,cetId){
         window.location.href="replayListH5.html";
         FLMethodXQModel.takeParmToNextPgeNameImageTimeContentCetID(name,tupian,time,content,cetId);
     }

function clickToCheackMore(){
    location.href = "nima://xjClickToCheckMoreJudgePL";
//    location.href = "nima://xjClickToCheckMoreWithJudgePJ";
}





