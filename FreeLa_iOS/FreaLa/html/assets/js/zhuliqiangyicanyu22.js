   $(document).ready(function(){

    //获取活动详情
    window.details.getDetails();

    window.details.sendUserId();
    window.details.sendParticipateNum();
    window.details.zhulitopicqiang();
    //判断是不是商家
    window.details.CheckDecisison();
    //转发
    $(".pull-right3").click(function(){
    window.details.shareType("zf")
    window.details.zhuanfaling();
    });

    $(".sous_btn").click(function(){
    var nickname =$("#findHelper").val();
    window.details.searchHelper(nickname);
//    alert($("#findHelper").val());
    });
    $("#watchMine").click(function(){
    window.location.href="minezhuliqianglist.html";
    });



});
//var BaseUrl="http://123.57.35.196:80";
//var BaseUrl="http://59.108.126.36:8585";
//var BaseUrl="http://192.168.20.79:8888"
//var BaseUrl="http://59.108.126.36:8888";
     var acctype="person"

var BaseUrl="http://www.freela.com.cn";
var UserId=0;
var DetailsJson="";



function topiczhuliqiang(zhuliTopicJson){
if(zhuliTopicJson!=null){
var layout="";
var topicJson=zhuliTopicJson;
for(var i=0;i<topicJson.length;i++){

         if(topicJson[i].userId==UserId){
          $("#rank").html(topicJson[i].rank);
          if(parseInt(DetailsJson.lowestNum)>parseInt(topicJson[i].num)){
            $("#multiple").html("   "+parseInt(DetailsJson.lowestNum)-parseInt(topicJson[i].num)+"");
            }else if(parseInt(DetailsJson.lowestNum)<=parseInt(topicJson[i].num)){
              $("#whyreceive").html("您达到了领取标准");
            }
         }

         if(parseInt(DetailsJson.lowestNum)<=parseInt(topicJson[i].num)){
          layout+='<div class="can_lun" id="paricpate_'+topicJson[i].participateId+'">'
                              if((i+1)<=DetailsJson.topicNum){
                              layout+='<h1>'+(i+1)+'</h1>'
                              }else{
                              layout+='<h1 style="color:#2d2d2d">'+(i+1)+'</h1>'
                              }
                              layout+='<div class="box_1">'
                              layout+='<div style="width: 50px;height: 50px;border-radius: 50px;overflow: hidden;background-size: contain;float: left;">'
                                  layout+='<img src="'+BaseUrl+topicJson[i].avatar+'" alt="" style="float: left;width:50px;height: 50px;" onclick="participateId('+topicJson[i].participateId+',\''+topicJson[i].nickname+'\')">'
                                  layout+='</div>'
                                  layout+=' <div class="can_lun2" onclick="participateId('+topicJson[i].participateId+',\''+topicJson[i].nickname+'\')">'
                                      layout+=' <span class="span_1">'+topicJson[i].nickname+'</span>'
                                      if(DetailsJson.zlqRule=="TOP"){
                                      layout+='<h2 class="can_date">达到时间:'+topicJson[i].promateTime+'</h2>'
                                      }else{
                                      layout+='<h2 class="can_date">达到时间:'+topicJson[i].lockTime+'</h2>'
                                      }
                                  layout+='</div>'
                              if(topicJson[i].ispromote){
                              layout+='<div class="bb"  onclick="dianzan('+topicJson[i].participateId+',\''+topicJson[i].num+'\','+topicJson[i].ispromote+')"><img src="images/zan-ico.png"></div>'
                              }else{
                              layout+='<div class="bb" onclick="dianzan('+topicJson[i].participateId+',\''+topicJson[i].num+'\','+topicJson[i].ispromote+')"><img src="images/zan-ico-gray.png"></div>'
                              }
                              if((i+1)<=DetailsJson.topicNum){
                              layout+='<div class="bb" style="color: #f87d7b">'+topicJson[i].num+'</div>'
                              }else{
                               layout+='<div class="bb">'+topicJson[i].num+'</div>'
                              }
                              layout+='</div>'
                              layout+='</div>'
         }else{
        layout+='<div class="can_lun" id="paricpate_'+topicJson[i].participateId+'">'
                    layout+='<h1 style="color:#2d2d2d">'+(i+1)+'</h1>'
                     layout+='<div class="box_1" >'
                     layout+='<div style="width: 50px;height: 50px;border-radius: 50px;overflow: hidden;background-size: contain;float: left;">'
                     layout+='<img src="'+BaseUrl+topicJson[i].avatar+'" alt="" style="float: left;width:50px;height: 50px;" onclick="participateId('+topicJson[i].participateId+',\''+topicJson[i].nickname+'\')">'
                     layout+='</div>'
                     layout+=' <div class="can_lun2" onclick="participateId('+topicJson[i].participateId+',\''+topicJson[i].nickname+'\')">'
                     layout+=' <span class="span_1">'+topicJson[i].nickname+'</span>'
                     layout+='</div>'
                     if(topicJson[i].ispromote){
                     layout+='<div class="bb" onclick="dianzan('+topicJson[i].participateId+',\''+topicJson[i].num+'\','+topicJson[i].ispromote+')"><img src="images/zan-ico.png" ></div>'
//                     layout+='<div class="bb" style="color: #f87d7b">'+topicJson[i].num+'</div>'
                     }else {
                     layout+='<div class="bb"  onclick="dianzan('+topicJson[i].participateId+',\''+topicJson[i].num+'\','+topicJson[i].ispromote+')"><img src="images/zan-ico-gray.png"></div>'
//                     layout+='<div class="bb">'+topicJson[i].num+'</div>'
                     }
                     layout+='<div class="bb">'+topicJson[i].num+'</div>'
                 layout+='</div>'
                 layout+='</div>'
               }
}
$("#goperzhuli").html(layout);
  }
}
     /**
     *判断是不是商家
     **/
     function panduantype(acctype){
     if(acctype=="comp"){
     $('.bb').attr("style","display:none");
     $("#whyreceive").html("商家号不能参与活动");
     $("#bigrank").html("  ");
     }
     }

  function participateId(id,nickname){
   window.details.participateId(id,nickname);
   window.details.openPerZhuLi();
  }
  function dianzan(id,num,state){
    if(!state){
     window.details.insertProme(id);
     $("#dianzan"+id).html(num*1+1);
    }else {
     window.details.insertProme(id);
    }
  }
   function Deatils(jsonDate){
   DetailsJson=jsonDate.data;
   jsonDate=jsonDate.data;
//   $("#topnum").html(jsonDate.lowestNum);
//   $("#receiveNum").html(jsonDate.receiveNum);
//   $("#totalNum").html(jsonDate.receiveNum+"/"+jsonDate.topicNum);
   if(jsonDate.zlqRule=="FIRST"){
   $("#poorzl").html("最低助力数"+jsonDate.lowestNum+",先到先得");
   }else{
   $("#rule").html("最低助力数"+jsonDate.lowestNum+",Top领取");
   }
//   if(jsonDate.participateId==null||jsonDate.assiNum==0){
//   $("#watchMine").attr("style","display:none");
//   $("#bigRank").attr("style","display:none");
//   $("#whyreceive").html("快去参与助力抢吧!");
//   }else{
//   $("#watchMine").attr("style","display:block");
//   $("#bigRank").attr("style","display:block");
//   }
        var endTime=jsonDate.endTime;    //结束时间
        var newTime=jsonDate.newDate;//系统当前时间
        var newTime_ms=Date.parse(new Date(newTime.replace(/-/g, "/")));//系统当前时间
        var endtime_ms = Date.parse(new Date(endTime.replace(/-/g, "/")));   // endtime 为结束时间

        //计算出相差天数
        var diff=endtime_ms-newTime_ms;
   //     alert(diff);
        var days=Math.floor(diff/(24*3600*1000));
        //计算出小时数
        var leave1=diff%(24*3600*1000);    //计算天数后剩余的毫秒数
        var hours=Math.floor(leave1/(3600*1000));
        //计算相差分钟数
        var leave2=leave1%(3600*1000);        //计算小时数后剩余的毫秒数
        var minutes=Math.floor(leave2/(60*1000));
        if(days>0){
        if(hours>=0&&hours<=9){
        $("#dhtime").html(days);
        $("#dhlock").html("天");
        $("#hmtime").html("0"+hours);
        $("#hmlock").html("小时");
        }else if(hours>9){
        $("#dhtime").html(days);
        $("#dhlock").html("天");
        $("#hmtime").html(hours);
        $("#hmlock").html("小时");
        }
        }
        else if(days<0){
        $("#diff").html("活动已结束");
        }else if(days==0&&hours>0&&minutes>=0){
              if(hours>0&&hours<=9&&minutes>=0&&minutes<=9){
              $("#dhtime").html("0"+hours);
              $("#dhlock").html("小时");
              $("#hmtime").html("0"+minutes);
              $("#hmlock").html("分");
              }else if(hours>0&&hours<=9&&minutes>9){
              $("#dhtime").html("0"+hours+"时");
              $("#dhlock").html("小时");
              $("#hmtime").html(minutes);
              $("#hmlock").html("分");
              }else if(hours>9&&minutes>=0&&minutes<=9){
              $("#dhtime").html(hours);
              $("#dhlock").html("小时");
              $("#hmtime").html("0"+minutes);
              $("#hmlock").html("分");
              }else{
              $("#dhtime").html(hours);
              $("#dhlock").html("小时");
              $("#hmtime").html(minutes);
              $("#hmlock").html("分");
        }
        }else if(days==0&&hours==0&&minutes>=0){
         $("#diff").html("距离活动结束还有"+minutes+"分");
        }if(jsonDate.receiveNum==jsonDate.topicNum){
         $("#diff").html("活动已结束");
        }
      }
   //一共有多少人参与了活动
   function ParticipateNum(ParticipateNum){
   $("#ParticipateNum").html("已参与"+ParticipateNum+"人");
   }
   function useUserId(userId){
   UserId=userId;
   }



