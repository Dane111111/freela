$(document).ready(function(){
 //获取星星
  window.details.getStar();
    //获取评价列表
  window.details.getJudgeInfo();

});
//var BaseUrl="http://59.108.126.36:8888/";
//var BaseUrl="http://123.57.35.196:80";
//var BaseUrl="http://59.108.126.36:8585";
//var BaseUrl="http://192.168.20.79:8888"
//var BaseUrl="http://59.108.126.36:8888";
var BaseUrl="";
//获取星星
function getStar1(starJson){
//获取打分星星的js
  if(starJson[0].countavg!=0){
   if(starJson[0].countavg>1&&starJson[0].countavg<2){
       $("#stare").html('<span class="star6 active" _val=6 ></span>')
       }else if(starJson[0].countavg>2&&starJson[0].countavg<3){
       $("#stare").html('<span class="star7 active" _val=7 ></span>')
       }else if(starJson[0].countavg>3&&starJson[0].countavg<4){
        $("#stare").html('<span class="star8 active" _val=8 ></span>')
       }else if(starJson[0].countavg>4&&starJson[0].countavg<5){
        $("#stare").html('<span class="star8 active" _val=9 ></span>')
       }else{
         $("#stare").html('<span class="star'+Math.round(starJson[0].countavg)+' active" _val='+Math.round(starJson[0].countavg)+'></span>');
       }
  }
}
  var judge="";
  var layout="";
function JudgeInfo(judgeJson){
//alert(judgeJson);
if(judgeJson==null||judgeJson==""){
 $("#judege_list").attr("style","display:block");
}
judge=judgeJson;
  for(var i=0;i<judge.length;i++){
  //有图片评论的列表
  if(judge[i].imgUrls!=null&&judge[i].imgUrls!=""){
       layout+='<div class="user-pinglun">'
       layout+='<div class="user-head">'
       layout+='<img src="'+BaseUrl+judge[i].avatar+'" width="46" height="46">'
       layout+='<div class="head-name" style="padding-bottom: 15px;">'
       layout+='<p class="pr-spot-desc2 free_dis4" style="padding-top: 15px;">'+judge[i].nickname+'</p>'
       layout+='<div class="commstar2" style="margin-left: 10px;">'
       if(judge[i].rank==0){
       layout+=' <span class="star'+judge[i].rank+'" ="'+judge[i].rank+'b"></span>'
       }else{
       layout+=' <span class="star'+judge[i].rank+'-2 active2" _val="'+judge[i].rank+'b"></span>'
       }
       layout+='</div>'
       layout+='<div class="head-time"><span class="pr-spot-desc2 free_dis4">'+judge[i].createTime+'</span></div>'
       layout+='</div>'
       layout+='</div>'
       layout+='<div style="clear:both;"></div>'
       layout+='<div><span class="pr-spot-desc3 free_dis9">'+judge[i].content+'</span></div>'
       layout+='</div>'
       layout+='<div class="shaitu">'
       layout+='<table>'
       layout+='<tr>'
       for(var j=0;j<judge[i].listImgURL.length;j++){
       layout+='<td><a data-href="#" href="#none" data-ind=""><img  src="'+BaseUrl+judge[i].listImgURL[j]+'"/></a></td>'
       }
       layout+='</tr>'
       layout+='</table>'
       layout+='</div>'
       }
       else{
       //没有图片的评价
       layout+='<div class="user-pinglun">'
       layout+='<div class="user-head">'
       layout+=' <img src="'+BaseUrl+judge[i].avatar+'" width="56" height="56">'
       layout+='<div class="head-name"style="padding-bottom: 15px;">'
       layout+='<p class="pr-spot-desc2 free_dis4"  style="padding-top: 15px;">'+judge[i].nickname+'</p>'
       layout+='<div class="commstar2" style="margin-left: 10px;">'
       layout+=' <span class="star'+judge[i].rank+'-2 active2" _val="'+judge[i].rank+'b"></span>'
       layout+='</div>'
       layout+='<div class="head-time"><span class="pr-spot-desc3 free_dis9">'+judge[i].createTime+'</span></div>'
       layout+='</div> '
       layout+='</div>'
       layout+='<p style="padding-top:10px;"><span class="pr-spot-desc3 free_dis9">'+judge[i].content+'</span></p>'
       layout+='</div>'
       }
           }

       $("#layout").html(layout);
    }