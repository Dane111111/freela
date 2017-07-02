 /**
      *creatby zhangruofei
      *creatTime 2016-5-24
      * 评论js
      **/
var xj_Is_H5_Page =false;
$(document).ready(function(){
                  //获取评论内容
                  //        window.details.getComment();
                  $(".z_btn").click(function(){
                                    var comInfo= $(".z_ipt").text();
//                                    comInfo = comInfo.replace(/<\/ ?[^>]*>/g, ''); //去除HTML tag
//                                    comInfo = comInfo.replace(/[ | ]*\n/g, ''); //去除行尾空白
//                                    comInfo = comInfo.replace(/&nbsp;/ig, '');//去掉空格
                                    var comtent =comInfo.trim();
                                    if(comtent!=null&&comtent!=""){
                                    var commandName = 'xjInsertJudgeCommentWithStr';
                                    location.href = 'js-call:' + commandName + ':' + encodeURIComponent(comtent);
                                    $(".z_ipt").text("");
                                    }else{
                                    swal("内容不能为空！！！");
                                    }
                                    });
                  
                  
                  $(document).scroll(function(){
                                     var top = document.body.scrollTop;
                                     if(top<200){
                                     $(".pull-left11").hide();
                                     }else if(top>200){
                                     $(".pull-left11").show();
                                     }
                                     });

                  
                  });

var BaseUrl="";

//评论
function xjcommentInfo(commentJson,xjPLListIsFull){
//    alert('sadas');
    var pinglunJson=commentJson;
    var pinglunlayout="";
    $("#commentLayout").empty();
    
    if(pinglunJson!=null&&pinglunJson!=""){
        for(var i=0;i<pinglunJson.length;i++){
            pinglunlayout+='<div class="z_comment"  onclick="commentIdd(\''+pinglunJson[i].nickname+'\',\''+pinglunJson[i].avatar+'\',\''+pinglunJson[i].createTime+'\',\''+pinglunJson[i].content+'\',\''+pinglunJson[i].commentId+'\')">'
            pinglunlayout+='<span class="z_sp"><img src="'+pinglunJson[i].avatar+'" alt=""/></span>'
            pinglunlayout+='<div class="z_conts" style="width:72%;">'
            pinglunlayout+='<p class="z_p1">'+pinglunJson[i].nickname+'</p>'
            pinglunlayout+='<p class="z_p2">'+pinglunJson[i].createTime+'</p>'
            
            pinglunlayout+='<p class="z_p3">'+pinglunJson[i].content+'</p>'
            pinglunlayout+='</div>'
             pinglunlayout+='<p style="float: right;width: 20px;text-align: center;margin-top: 0px;font-size: 12px;color: #6f6f6f;">'+pinglunJson[i].replies+'</p>'
            pinglunlayout+='<div class="z_conright">'
            pinglunlayout+='<a href="javascript:void(0)"><img src="./images/weixin.png" alt=""/ style="width:16px;height:16px;"></a>'
            pinglunlayout+='</div>'
            pinglunlayout+='</div>'
        }
        if(xjPLListIsFull){
            pinglunlayout+='<div class="lookpinglun" style="border-top:0px solid #e3e3e3;">'
            pinglunlayout+='<a class="pr-spot-desc4 free_dis19 "style="display:block;width: 34%;margin: 0 auto;margin-top:10px;margin-bottom: 10px;">全部加载完毕</a>'
            pinglunlayout+='</div>'
        }else{
            pinglunlayout+='<div class="lookpinglun" style="border-top:0px solid #e3e3e3;">'
            pinglunlayout+='<a class="pr-spot-desc4 free_dis19 "style="display:block;width: 34%;margin: 0 auto;margin-top:10px;margin-bottom: 10px;" onclick="clickToCheackMore()">查看更多评论</a>'
            pinglunlayout+='</div>'
        }
        
        $("#commentLayout").html(pinglunlayout);
    }
    
}

     function keybordHeight(mkeybordHeight){
            z_Height = mkeybordHeight;

     }
//回复评论
function commentIdd(name,tupian,time,content,cetId){
    window.location.href="replayListH5.html";
    FLMethodXQModel.takeParmToNextPgeNameImageTimeContentCetID(name,tupian,time,content,cetId);
}

function clickToCheackMore(){
    location.href = "nima://xjClickToCheckMoreJudgePL";
    //    location.href = "nima://xjClickToCheckMoreWithJudgePJ";
};


function xj_is_h5_CommentPage() {
    xj_Is_H5_Page = true;
    
}

function xjGoBackBtnClickInHfive() {
    if(xj_Is_H5_Page){
        //执行其他代码
        location.href="nima://xjGoBackBtnClickInHFive";
    } else {
        history.back(-1);
    }
}





