
//var BaseUrl = "http://192.168.20.53:8080";
//var BaseUrl = "http://59.108.126.36:8585";
//var BaseUrl = "http://59.108.126.36:8888"; //测试
var BaseUrl = ""; //测试
$(document).ready(function(){
 
                  $(document).scroll(function(){
                                     var top = document.body.scrollTop;
                                     if(top<200){
                                    $(".pull-left11").hide();
                                     }else if(top>200){
                                     $(".pull-left11").show();
                                     }
                                     });

});


//获取评价列表 和星星
var flXQJudgeListArray ;
var flXQJudgeListStarDic;
var xj_is_PJ_full;
function flXQgetJudgeListInHTML(judgelistArray,judgelistStarDic,xjIsJudgeListPJFull)
{
    
    flXQJudgeListArray = judgelistArray;
    flXQJudgeListStarDic = judgelistStarDic;
    xj_is_PJ_full = xjIsJudgeListPJFull;
//    alert(judgelistArray[0]);//test
//    alert(flXQJudgeListStarDic[0].countavg); //test
    //获取星星
    if(flXQJudgeListStarDic[0].countavg==0){
        $("#stare").html('<span class="star'+flXQJudgeListStarDic[0].countavg+' " _val='+flXQJudgeListStarDic[0].countavg+'></span>');
    } else{
      $("#stare").html('<span class="star'+flXQJudgeListStarDic[0].countavg+' active" _val='+flXQJudgeListStarDic[0].countavg+'></span>');
    }
//    $("#starnum").html(flXQJudgeListStarDic[0].countavg);
    JudgeInfo(judgelistArray);
}

function JudgeInfo(judgeJson){
    var judge="";
    var layout="";
    //alert(judgeJson);
    if(judgeJson==null||judgeJson==""){
        $("#judege_list").attr("style","display:block");
    }
    judge=judgeJson;
    for(var i=0;i<judge.length;i++){
        //有图片评论的列表
        if(judge[i].imgUrls!=null&&judge[i].imgUrls!=""){
            layout+='<div class="user-pinglun" style="padding: 10px;">'
            layout+='<div class="user-head">'
            layout+='<img src="'+judge[i].avatar+'" style="width:25px;height:25px;">'
            layout+='<div class="head-name">'
            layout+='<p class="pr-spot-desc2 free_dis4" style="float: left;padding-top: 10px;margin-left:10px;">'+judge[i].nickname+'</p>'
            layout+='<div class="head-time"><span class="pr-spot-desc2 free_dis4" style="float: right;">'+judge[i].createTime+'</span>'
            layout+='</div>'
            layout+='</div>'
            layout+='</div>'
            layout+='<div style="clear:both;"></div>'
            layout+='<div>'
            layout+='<div style="width:100%;height:1px;background: #e3e3e3;margin-top: 10px;"></div>'
            layout+='<div class="commstar2">'
            layout+=' <span class="star'+judge[i].rank+'-2 active2" _val="'+judge[i].rank+'b"></span>'
            layout+='</div>'
            layout+='<div>'
            layout+='<span class="pr-spot-desc3 free_dis9" style="margin-left: 8px;">'+judge[i].content+'</span>'
            layout+='</div>'
            layout+='</div>'
            layout+='</div>'
            layout+='<div class="shaitu"  style="border-bottom: #e3e3e3 10px solid;">'
            layout+='<table>'
            layout+='<tr>'
            for(var j=0;j<judge[i].listImgURL.length;j++){
                layout+='<td><a data-href="#" href="#none" data-ind=""><img  src="'+judge[i].listImgURL[j]+'" style="width: 95px;height: 95px;"/></a></td>'
            }
            layout+='</tr>'
            layout+='</table>'
            layout+='</div>'
        }
        else{
            //没有图片的评价
            layout+='<div class="user-pinglun" style="padding: 10px;">'
            layout+='<div class="user-head">'
            layout+='<img src="'+judge[i].avatar+'" style="width:25px;height:25px;">'
            layout+='<div class="head-name">'
            layout+='<p class="pr-spot-desc2 free_dis4" style="float: left;padding-top: 10px;margin-left:10px;">'+judge[i].nickname+'</p>'
            layout+='<div class="head-time"><span class="pr-spot-desc2 free_dis4" style="float: right;">'+judge[i].createTime+'</span>'
            layout+='</div>'
            layout+='</div>'
            layout+='</div>'
            layout+='<div style="clear:both;"></div>'
            layout+='<div>'
            layout+='<div style="width:100%;height:1px;background: #e3e3e3;margin-top: 10px;"></div>'
            layout+='<div class="commstar2">'
            layout+=' <span class="star'+judge[i].rank+'-2 active2" _val="'+judge[i].rank+'b"></span>'
            layout+='</div>'
            layout+='<div>'
            layout+='<span class="pr-spot-desc3 free_dis9" style="margin-left: 8px;">'+judge[i].content+'</span>'
            layout+='</div>'
            layout+='</div>'
            layout+='</div>'
            layout+='<div style="border-bottom: #e3e3e3 10px solid;"></div>'
        }
    }
    if(xj_is_PJ_full) {
        layout+='<div class="lookpinglun" style="border-top:0px solid #e3e3e3;">'
        layout+='<a class="pr-spot-desc4 free_dis19 "style="display:block;width: 34%;margin: 0 auto;margin-top:10px;margin-bottom: 10px;">全部加载完毕</a>'
        layout+='</div>'
    } else {
        layout+='<div class="lookpinglun" style="border-top:1px solid #e3e3e3;">'
        layout+='<a class="pr-spot-desc4 free_dis19 "style="display:block;width: 34%;margin: 0 auto;margin-top:10px;margin-bottom: 10px;" onclick="clickToCheackMoreWithPJ()">查看更多评论</a>'
        layout+='</div>'
    }
    $("#layout").html(layout);
}

function clickToCheackMoreWithPJ(){
    location.href = "nima://xjClickToCheckMoreWithJudgePJ";
}




