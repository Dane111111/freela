   $(document).ready(function(){

    //获取活动详情
//    window.details.searchPomote();

});

var BaseUrl="";
function writeReceive1(searchPo,DetailsJson){
//    alert(searchPo);
if(searchPo!=null){
var layout="";
var topicJson=searchPo[0].data;
//    alert(topicJson);
for(var i=0;i<topicJson.length;i++){

    layout+='<div class="can_lun">'
    layout+='<h1  style="width:45px;">'+topicJson[i].rank+'</h1>'
    layout+='<div class="box_1">'
    layout+='<div style="width: 50px;height: 50px;border-radius: 50px;overflow: hidden;background-size: contain;float: left;">'
    if(topicJson[i].avatar!=null){
        layout+='<img src="'+BaseUrl+topicJson[i].avatar+'" alt="" style="float: left;width:50px;height: 50px;">'
    }else{
        layout+='<img src="images/my_icon.png" alt="" style="float: left;width:50px;height: 50px;">'
    }
    layout+='</div>'
    layout+='<div class="can_lun2" onclick="participateId('+topicJson[i].participateId+',\''+topicJson[i].nickname+'\')">'
    layout+='<span class="span_1">'+topicJson[i].nickname+'</span>'
    if(topicJson[i].promateTime!=null){
        layout+='<h2 class="can_date">'+topicJson[i].promateTime+'</h2>'
    }else if(topicJson[i].lockTime!=null){
        layout+='<h2 class="can_date">'+topicJson[i].lockTime+'</h2>'
    }
    layout+='</div>'
    if(topicJson[i].ispromote){
        layout+='<div class="bb"  onclick="dianzan('+topicJson[i].participateId+',\''+topicJson[i].num+'\','+topicJson[i].ispromote+')"><img src="images/zan-ico.png"></div>'
    }else{
        layout+='<div class="bb" id="pomote'+topicJson[i].participateId+'"   onclick="dianzan('+topicJson[i].participateId+',\''+topicJson[i].num+'\','+topicJson[i].ispromote+')"><img src="images/zan-ico-gray.png"></div>'
    }
    if(DetailsJson.topicNum<=topicJson[i].num){
        layout+='<div class="bb" id="dianzan'+topicJson[i].participateId+'" style="color: #f87d7b">'+topicJson[i].num+'</div>'
    }else{
        layout+='<div class="bb" id="dianzan'+topicJson[i].participateId+'">'+topicJson[i].num+'</div>'
    }
    layout+='</div>'
    layout+='</div>'
  }
    
   $("#goperzhuli").html(layout);

//  		$(document).scroll(function(){
//  		var top = document.body.scrollTop;
//  		console.log(top);
//  		if(top<200){
//          $(".pull-left10").hide().fadeOut(2000,.5);
//  		}else if(top>=200){
//  		$(".pull-left10").show();
//  		    }
//  	    });
}
}

  function participateId(id,nickname){
//   window.details.participateId(id,nickname);
//   window.details.openPerZhuLi();
      
      //    FLMethodXQModel.participateIdInZhuliqiangJSNickname(id,nickname); //传给原生
      location.href='js-call' + ':' + 'xjPushPerZLQAndPassId'+ ':' + encodeURIComponent(id+','+nickname);
  }
  function dianzan(id,num,state){
      if(state == true){
          
          //       alert(state);
          location.href = 'js-call:' + 'xjAlertInfoWithStr' + ':' + encodeURIComponent("您已助力，不能重复助力！");
      } else {
          location.href = 'js-call:' + 'FLFLHTMLActionPerZhuliqiangHelpClick' + ':' + encodeURIComponent(JSON.stringify(id));
              $("#dianzan"+id).html(num*1+1);
              $("#pomote"+id).html('<img src="images/zan-ico.png" >');
          layout = "";
      }
  }

function xjHrefZlqHtmlPage() {
    window.location.href="zhuliqianglist.html";
}



