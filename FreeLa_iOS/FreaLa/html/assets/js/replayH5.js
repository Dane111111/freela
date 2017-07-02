$(document).ready(function(){

  $(".z_btn").click(function(){
  var comInfo= $(".z_ipt").text();
//  comInfo = comInfo.replace(/<\/ ?[^>]*>/g, ''); //去除HTML tag
//  comInfo = comInfo.replace(/[ | ]*\n/g, ''); //去除行尾空白
//  comInfo = comInfo.replace(/&nbsp;/ig, '');//去掉空格
  var comtent =comInfo.trim();
  if(comtent!=null&&comtent!=""){
//  window.details.sendreplayInfo(comtent);
                    var commandName = 'xjInsertJudgeBackWithStr';
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
function flReJudgegetInfoInHTML(name1,tupian2,time3,content4,hehe){
    
    $("#cetname").html(name1);
    $("#cettime").html(hehe);
    $("#cetcontent").html(time3);
    $("#head-img").attr("src",tupian2);
}



function replayList(relayJson){
var layout=""
     for(var i=0;i<relayJson.length;i++){
     if(relayJson.length!=null){
     if(i==0){
          layout+='<div class="z_comment z_cson">'
                  layout+='<p class="z_whole">全部回复</p>'
                  layout+='<span class="z_sp"><img src="'+relayJson[i].avatar+'" alt=""/></span>'
                  layout+='<div class="z_conts z_tson">'
                      layout+='<p class="z_p1">'+relayJson[i].nickname+'</p>'
                      layout+='<p class="z_p2">'+relayJson[i].createTime+'</p>'
                      layout+='<p class="z_p3">'+relayJson[i].content+'</p>'
                  layout+='</div>'
              layout+='</div>'
     }else{
     layout+='<div class="z_comment z_cson">'
             layout+='<span class="z_sp"><img src="'+relayJson[i].avatar+'" alt=""/></span>'
             layout+='<div class="z_conts z_tson">'
                 layout+='<p class="z_p1">'+relayJson[i].nickname+'</p>'
                 layout+='<p class="z_p2">'+relayJson[i].createTime+'</p>'
                 layout+='<p class="z_p3">'+relayJson[i].content+'</p>'
             layout+='</div>'
         layout+='</div>'
         }
            }
         }
            layout+='<div style="height:40px;"></div>'
  
         $("#relayId").html(layout);
}


