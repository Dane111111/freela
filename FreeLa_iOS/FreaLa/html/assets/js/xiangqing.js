//
//  File.js
//  FreaLa
//
//  Created by 楚志鹏 on 15/9/16.
//  Copyright (c) 2015年 FreeLa. All rights reserved.
//

//var BaseUrl = "http://59.108.126.36:8888"; //测试
//var BaseUrl = "http://192.168.20.79:8888";
var BaseUrl  ="";   //freela
var xj_is_screen_width_5="";
//var isHidden ;
var xj_local_phone=false;
$(document).ready(function()
                  {
                  
                  
                  //点击领取事件
                  $('#receive').click(function(){
//                                           FLMethodXQModel.flinsertParticipate(); //for test
                                           });
                  //点击评价事件
                  $('#pingjianum').click(function(){
                                         
//                  FLMethodXQModel.getJudgeListgetJudgeListAndStar();
                                         $('#fljudgeList').attr('href','judgelist.html');
//
                  });
                  //地址点击事件
                  $('.pr-adress').click(function(){
                                        location.href="nima://wozhenshirilegoudizhi";
                                        
                                        });
                  //点击下方评论菜单
                  $('#pinglun-2').click(function(){
                                       location.href="nima://FLFLHTMLAlertJudgeWindow"; //FLFLHTMLAlertJudgeWindow
                                        });
                  //点击关注事件
                  $('#guanzhuTa').click(function(){
                                        FLMethodXQModel.fltakeCareToTopicOwnerUserType(flXQInfoModel.userId,flXQInfoModel.userType);
                                        });  //comp_look
                  //点击关注事件2(传出去是不是关注领)
                  $('#comp_look').click(function(){
                                        location.href="nima://xjHTMLCareOnly";
                                        });
                  //点击举报事件
                  $('#jubao-menu').click(function(){
//                                         isHidden = 1 ;
                                        FLMethodXQModel.flSethiddenWithNavi(1);
                                        });
                  //返回点击事件
                  $(".pull-left").click(function(){
                                        window.location.href="nima://flGoBackToTabBarMenu";
                                         });
                  //分享点击事件fenxiang-btn    sharenum   share-yes
                  $('.fenxiang-btn11').click(function(){
                                        window.location.href="nima://XJAlertActionSheet"; //FLFLHTMLShareToFriendWithAnyType
                                        });
                  $('#fenxiang').click(function(){
                                           window.location.href="nima://FLFLHTMLShareToFriendWithAnyType"; //FLFLHTMLShareToFriendWithAnyType
                                           });
                  $('.share-yes').click(function(){
//                                        alert('s');
                                       window.location.href="nima://FLFLHTMLShareToFriendWithAnyType"; //FLFLHTMLShareToFriendWithAnyType
                                       });
                  //顶部 收藏点击事件shoucang-btn   shoucang-->
                  $(".shoucang-btn").click(function(){
//                                        FLMethodXQModel.flcollectionTopicInMine();
//                                           if(xjCollectionOrNot){
//                                           $("#shoucang").attr("class","d-menu3");
//                                           xjCollectionOrNot = false;
//                                           } else {
//                                           $("#shoucang").attr("class","d-menu5");
//                                           xjCollectionOrNot = true;
//                                           }
                                           location.href="jubao.html";
                                        });
                   //收藏点击事件shoucang-btn   shoucang
                  $('#shoucang').click(function(){
//                                           FLMethodXQModel.flcollectionTopicInMine();
                                           location.href="nima://xjIsCollecitonClick";
                               
                                           });
                  $('.pull-left11').click(function(){
                                       // FLMethodXQModel.flcollectionTopicInMine();
                                       location.href="nima://flGoBackToTabBarMenu";
                                       
                                       });
                  
                  
                  $(document).scroll(function(){
                                     var top = document.body.scrollTop;
//                                     console.log(top);
                                     if(top<200){
//                                     $(".pull-left11").hide();
                                     $("#right").hide();
                                     }else if(top>200){
                                     $(".pull-left11").show();
                                     $("#right").show();   //flGoBackToTabBarMenu
                                     }
                                     });
               
                  //                  initpage(); //给界面赋值
//                   location.href="nima://getDetailsInfoInFuckHtmlVC";   //检查领取资格
//                   location.href="nima://xgetHelpListHeadImageFromService";  //查看助力￥参与列表信息
                  });

//得到详情模型  如果没有，则什么都不显示
 //定义全局变量model

//var flXQInfoStarArray;//星星
//var flXQInfoQualificationData; //获取领取资格
function flGetJSXQInfomation(TopicModel) //模型
{
    
    var nidaye        = TopicModel;
//    flXQInfoStarArray   = TopicStarArray;
//    flXQInfoQualification = TopicQualificationData;
//    alert(TopicQualificationData.success); //for test
//    alert('sss');
    initpage(nidaye);
 
    getTopicPic();
//
};
function xj_js_check_localPhone (xjphone){
    xj_local_phone = xjphone;
    if(!xj_local_phone){
        $("#receive").click(function(){
                            //绑定手机     commandNameAndPushToBilnd
                            location.href = "nima://xjBlindYourPhoneNumber";
                            });
    }

}
//轮播图高度

function xjSetImageH(xjBannerImageH){
//    alert(xjBannerImageH);
    $('.swiper-container').css("height",xjBannerImageH);
}

var jsonDate = "";
var flXQInfoModel="";
//赋值
//var num1 = 1 ,num2 = 2,jindu = 3 ,diff = 4 ;
function initpage(nidaye)
{
    DeatilsJson=nidaye.data;
      jsonDate=nidaye.data;
      flXQInfoModel=jsonDate;
//    alert(flXQInfoModel.topicConditionKey);
//     alert(flXQInfoModel);
//    $('#num1').html(flXQInfoModel.pv); //阅读数
//    $('#num2').html(flXQInfoModel.transformNum); //分享数
    $('#jindu').html(flXQInfoModel.receiveNum); //参与进度
//    $('#topicTheme').html(flXQInfoModel.topicTheme); //标题
//    $('#rule').html(flXQInfoModel.rule); //限制
    if(jsonDate.topicPrice!=0){
        $(".pr-price1").html('<span class="pr-spot-desc free_dis" id="topicTheme">'+jsonDate.topicTheme+'</span> <span style="font-size:14px;color:#858585;">[价值</span>  <span style="font-size:20px;color:#f82f2d;" id="price">'+jsonDate.topicPrice+'</span> <span style="font-size:14px;color:#858585;">]</span>')
    }else if(jsonDate.topicPrice==0){
        $(".pr-price1").html('<span class="pr-spot-desc free_dis" id="topicTheme">'+jsonDate.topicTheme+'</span>')
    }
    //收藏数
    $("#shoucangnum").html('收藏('+flXQInfoModel.favNum+')');
    
    //设置发布者昵称
    $("#publisher-name").html(flXQInfoModel.nickName);
    //获取发布者头像
//    alert(flXQInfoModel.avatar);
    $("#publisher-head").attr("src",BaseUrl+ flXQInfoModel.avatar);
    //获取商品描述js
//    alert(flXQInfoModel.topicConditionKey);
//    alert(jsonDate.zlqRule);
    if(flXQInfoModel.topicConditionKey=="SUIXINLING"){
        $("#pubName").html("[随心领]");
        $("#rule_exp").html(jsonDate.rule);
        $("#rule_num").html(jsonDate.topicNum);
    }else if(flXQInfoModel.topicConditionKey=="ZHULIQIANG"&&flXQInfoModel.zlqRule=="TOP"){
        $("#pubName").html("[助力抢]");
        $("#rule_exp").html("TOP领取  最低助力数"+jsonDate.lowestNum+"个");
        $("#rule_num").html(jsonDate.topicNum);
    }else if(flXQInfoModel.topicConditionKey=="ZHULIQIANG"&&flXQInfoModel.zlqRule=="FIRST"){
        $("#pubName").html("[助力抢]");
        $("#rule_exp").html("先到先得  最低助力数"+jsonDate.lowestNum+"个");
        $("#rule_num").html(jsonDate.topicNum);

    }else if(flXQInfoModel.topicConditionKey=="ZHUANFALING"){
        $("#pubName").html("[转发领]");
        $("#rule_exp").html(jsonDate.rule);
        $("#rule_num").html(jsonDate.topicNum);
    }else if(flXQInfoModel.topicConditionKey=="GUANZHULING"){
        $("#pubName").html("[关注领]");
        $("#rule_exp").html(jsonDate.rule);
        $("#rule_num").html(jsonDate.topicNum);
    }
    //设置活动数量
    $("#topic-num").html("数量["+flXQInfoModel.topicNum+"]");
    //地址
    
    if(flXQInfoModel.address=="" || !flXQInfoModel.address ) {
//         alert(flXQInfoModel.address);
        $('.pr-adress').attr("style","display:none");
    } else {
//         alert(flXQInfoModel.address);
        $('.pr-adress').attr("style","display:block");
        $('#address').html(flXQInfoModel.address);
    }
    $('#price').html("￥"+flXQInfoModel.topicPrice); //价值
    //图文详情
//    alert(flXQInfoModel.details);
    if(flXQInfoModel.details!=null&&flXQInfoModel.details!="") {
//        $("#detailsInfo").attr("style","border-top:6px solid #f0eff4;display:block");
        $("#tuwen").html(flXQInfoModel.details);
        $("#tuwen").find("img").width("100%");
        $("#tuwen").find("img").height("100%");
        $("#tuwen a").attr("_href",$("#tuwen a").attr("href"));
        $("#tuwen a").attr("href","javascript:void(0)")
        $("#tuwen a").click(function(){
                            _this = $(this);
                            _href = _this.attr("_href");
                            if(_href.indexOf("http") < 0 ){
                            _href = "http://"+_href;
                            }
                            window.open(_href);
                            return ;
                            });
    }
    //简介
//    alert(flXQInfoModel.topicExplain);
    if(flXQInfoModel.topicExplain=="" || !flXQInfoModel.topicExplain) {
       
//        $(".pr-spot-desc2").attr("style","display:none");
    } else {
//         alert(flXQInfoModel.topicExplain);
        $("#jianjie").html(flXQInfoModel.topicExplain);
    }
    //剩余数量
    $("#surplus").html(jsonDate.topicNum-jsonDate.receiveNum);
    //进度
    var jindu="";
    var ranges=flXQInfoModel.topicNum;
    var receiveNum=flXQInfoModel.receiveNum;
    jindu=receiveNum/ranges*100;
//    var jindu2=changeTwoDecimal(jindu);
    var jindu2=jindu.toFixed(0);
    $("#jindu").html(jindu2+"%");
    
    //控制获取进度的js
    var progress=$("#progress");
    progress.css("width",jindu+"%");
    //控制获取进度的js
    if(jindu-10<=90&&jindu-10>=0){
        $("#level-div").html('<div class="level" id="level-div" style="margin-top:-15px;text-align:center;margin-left:'+(jindu-10)+'%"><span id="progress-level">'+jindu2+'%</span></div>');
    }else if(jindu-5>=0){
        $("#level-div").html('<div class="level" id="level-div" style="margin-top:-15px;text-align:center;margin-left:'+(jindu-2)+'%"><span id="progress-level">'+jindu2+'%</span></div>');
    }else {
        $("#level-div").html('<div class="level" id="level-div" style="margin-top:-15px;text-align:center;margin-left:'+jindu+'%"><span id="progress-level">'+jindu2+'%</span></div>');
    }
    //天数
    var createTime=flXQInfoModel.newDate;//开始时间
    var endTime=flXQInfoModel.endTime;    //结束时间
    var begintime_ms = Date.parse(new Date(createTime.replace(/-/g, "/"))); //begintime 为开始时间
    var endtime_ms = Date.parse(new Date(endTime.replace(/-/g, "/")));   // endtime 为结束时间
    var diff=endtime_ms-begintime_ms;
//    alert(diff);
    //计算出相差天数
    var days=Math.floor(diff/(24*3600*1000))
//        if(days<=0){
//            $("#diff").html(0);
//        } else if(days<=1){
//            $("#diff").html(1)
//        } else{
//            $("#diff").html(days);
//        }
    /******************************/
    //计算出小时数
    var leave1=diff%(24*3600*1000);    //计算天数后剩余的毫秒数
    var hours=Math.floor(leave1/(3600*1000));
    //计算相差分钟数
    var leave2=leave1%(3600*1000);        //计算小时数后剩余的毫秒数
    var minutes=Math.floor(leave2/(60*1000));
    if(flXQInfoModel.topicNum==flXQInfoModel.receiveNum) {
        $("#diff").html("已结束");
    } else if(days>0){
        if(hours>=0&&hours<=9&&minutes>=0&&minutes<=9){
            $("#diff").html(days+"天"+"0"+hours+"时"+"0"+minutes+"分");
        }else if(hours>=0&&hours<=9&&minutes>9){
            $("#diff").html(days+"天"+"0"+hours+"时"+minutes+"分");
        }else if(hours>9&&minutes>=0&&minutes<=9){
            $("#diff").html(days+"天"+hours+"时"+"0"+minutes+"分");
        }else{
            $("#diff").html(days+"天"+hours+"时"+minutes+"分");
        }
    }
    else if(days<0){
        $("#diff").html("已结束");
    }else if(days==0&&hours>0&&minutes>=0){
        if(hours>0&&hours<=9&&minutes>=0&&minutes<=9){
            $("#diff").html("0"+hours+"时"+"0"+minutes+"分");
        }else if(hours>0&&hours<=9&&minutes>9){
            $("#diff").html("0"+hours+"时"+minutes+"分");
        }else if(hours>9&&minutes>=0&&minutes<=9){
            $("#diff").html(hours+"时"+"0"+minutes+"分");
        }else{
            $("#diff").html(hours+"时"+minutes+"分");
        }
    }else if(days==0&&hours==0&&minutes>=0){
        $("#diff").html(minutes+"分");
    }
   
   /******************************/
    //起止时间
    str1 = flXQInfoModel.startTime.replace(/-/g,"/");
    var date1 = new Date(str1);
    str2 = flXQInfoModel.endTime.replace(/-/g,"/");
    var date2 = new Date(str2);
    //结束时间
    var endyear = date2.getFullYear();
    var endmonth = date2.getMonth()+1;//js从0开始取
    var enddate = date2.getDate();
    var endhour = date2.getHours();
    var endminutes = date2.getMinutes();
    
    if(endmonth<10){
        endmonth = "0" + endmonth;
    }
    if(enddate<10){
        enddate = "0" + enddate;
    }
    if(endhour <10){
        endhour = "0" + endhour;
    }
    if(endminutes <10){
        endminutes = "0" + endminutes;
    }
    //开始时间
    var beginingyear = date1.getFullYear();
    var beginingmonth = date1.getMonth()+1;//js从0开始取
    var beginingdate = date1.getDate();
    var begininghour = date1.getHours();
    var beginingminutes = date1.getMinutes();
    
    if(beginingmonth<10){
        beginingmonth = "0" + beginingmonth;
    }
    if(beginingdate<10){
        beginingdate = "0" + beginingdate;
    }
    if(begininghour <10){
        begininghour = "0" + begininghour;
    }
    if(beginingminutes <10){
        beginingminutes = "0" + beginingminutes;
    }
    

    var endcullert = endyear+"/"+endmonth+"/"+enddate+" "+endhour+":"+endminutes;
    var  beginingcullert=beginingyear+"/"+beginingmonth+"/"+beginingdate+" "+begininghour+":"+beginingminutes;
//    alert(formatDate(date1)+"--"+formatDate(date2));
    $('#endTime').html(beginingcullert+"--"+endcullert); //起止日期 --------需拼接新的字符串

    //活动简介
    if(flXQInfoModel.topicExplain!=null && flXQInfoModel.topicExplain!=""){
        $("#instructions").attr("style","display:block");
        $("#gouxian").attr("style","display:none");
        var topicExplain =flXQInfoModel.topicExplain.replace(/\n/g, "<br />");
        if(!pingjiabo){
            $("#instructions").attr("style","display:block");
            $("#missborder").attr("style","display:block");
//            location.href="111111111111111111111111111111111111111111111111";
            $("#instructions").html('<p style="border-bottom:1px solid #f0eff4;word-wrap: break-word;"></p><div class="pr-pingjia"><p class="pr-spot-desc2 free_dis2" style="margin-left:9px;color:#535353;margin-top:-5px;">使用说明:</p><p class="pr-spot-desc99 free_dis2 " style="word-wrap: break-word;" id="jianjie">'+topicExplain+'</p></div>');
        }else{
            $("#instructions").attr("style","display:block");
            $("#missborder").attr("style","display:block");
//            location.href="1222222222222222222222222222222222222222222222222";
            $("#instructions").html('<p style="border-bottom:1px solid #f0eff4;word-wrap: break-word;"></p><div class="pr-pingjia"><p class="pr-spot-desc2 free_dis2" style="margin-left:9px;color:#535353;margin-top:-5px;">使用说明:</p><p class="pr-spot-desc99 free_dis2 " id="jianjie" style="word-wrap: break-word;">'+topicExplain+'</p></div>');
        }
       
    } else {
          $("#instructions").attr("style","display:none");
        
    }
    //点击发布者头像跳转
    $("#comp-head").click(function(){
                          var xjPbulisherClick='xjPbulisherClick';
                          if(flXQInfoModel.userType=="person") {
                          location.href = 'js-call:' + xjPbulisherClick + ':' + encodeURIComponent("person,")+flXQInfoModel.userId;
                          } else {
                          location.href = 'js-call:' + xjPbulisherClick + ':' + encodeURIComponent("comp,")+flXQInfoModel.userId;
                          }
                          });
};

//设置统计数
function flXQPvUvTotalNumber(flXQPVUVModel){
//    alert(flXQPVUVModel.transformNum);
    $('#readnum').html(flXQPVUVModel.pv); //阅读数
//    alert(flXQPVUVModel.transformNum);
    //分享数
//    alert('sss');
    if(flXQPVUVModel.transformNum==""){
        $("#sharenum").html("分享(0)");
    }else{
        $("#sharenum").html("分享("+flXQPVUVModel.transformNum+")");
    }
    //收藏数
    $("#shoucangnum").html('收藏('+flXQPVUVModel.collentionNum+')');
    if(flXQPVUVModel.collentionNum==0) {
        $("#shoucangnum").html('收藏(0)');
    }
    
};

//输出时间格式
function formatDate(dd) {
//    alert(dd);
    var year=dd.getFullYear();
    var month=dd.getMonth()+1,date=dd.getDate();
    var hour=dd.getHours(),minute=dd.getMinutes();
    if(hour==0){
        hour='00';
    }
    if(minute==0){
        minute='00';
    }
    if(hour<=9&&minute>9){
    return  year+"/"+ month+"/"+date+" "+"0"+hour+":"+minute;
    }else if(hour>9&&minute<=9){
    return  year+"/"+ month+"/"+date+" "+hour+":"+"0"+minute;
    }else if(hour<=9&&minute<=9){
    return  year+"/"+ month+"/"+date+" "+"0"+hour+":"+"0"+minute;
    }else{
    return  year+"/"+ month+"/"+date+" "+hour+":"+minute;
    }
}

//从服务器获取图片适配到轮播图上

function flXQgetTopicPicInHtml(TopicPicArray)
{
    var flXQInfoPicArray;// 轮播图
    
        flXQInfoPicArray    = TopicPicArray;
    var mlayout="";
    var biglayout="";
    var url="";
    var arrs = "";
    for(var i=0;i<flXQInfoPicArray.length;i++){
        if(flXQInfoPicArray[i].businesstype==2){
//             url =flXQInfoPicArray[i].url.replace(/little_pc/, "little_app");  //替换
            url =flXQInfoPicArray[i].url;  //常规
            arrs = url.split("/");
            url = "";
            for (var j = 0; j < arrs.length; j++) {
                if (j == arrs.length - 1) {
                    url += "big_";
                    url += arrs[j];
                }else{
                    url += arrs[j] + "/";
                }
            }
//            alert(url);
            mlayout+='<div class="swiper-slide" style="background-image:url('+BaseUrl+flXQInfoPicArray[i].url+');background-size:100% 100%;">'
//            mlayout+='<img src="'+BaseUrl+flXQInfoPicArray[i].url+'" width="100%" heigth="500px"/>'
            mlayout+='</div>'
            biglayout+='<img src="'+BaseUrl+url+'" alt=""/>'
        }
        
    }
    $("#banner").html(mlayout);
    $("#z_show").html(biglayout);
    var swiper = new Swiper('.swiper-container', {
                            pagination: '.swiper-pagination',
                            paginationClickable: true,
                            spaceBetween: 0,
                            centeredSlides: true,
                            autoplay: 2500,
                            autoplayDisableOnInteraction: false
                            });
    
    
    
    
    //获取元素图片
    var z_lis = document.querySelectorAll(".swiper-wrapper div");
    var z_mask = document.querySelector("#z_mask");
    var z_show = document.querySelector("#z_show");
    var z_img = document.querySelectorAll("#z_show img");
    for (var i = 0; i < z_lis.length; i++) {
        z_lis[i].setAttribute("index", i);
        z_img[i].setAttribute("index", i);
        //循环添加click
        z_lis[i].addEventListener("click", function () {
                                  z_mask.style.display = "block";
                                  document.body.style.overflow = "hidden";
                                  z_show.style.display = "block";
                                  for (var j = 0; j < z_img.length; j++) {
                                  z_img[j].style.display = "none";
                                  }
                                  z_img[this.getAttribute("index")].style.display = "block";
                                  })
    }
    //遮罩层
    z_mask.addEventListener("click", function (event) {
                            var event = event || window.event;
                            var targetId = event.target ? event.target.id : event.srcElement.id;
                            if (targetId != "show") {
                            z_mask.style.display = "none";
                            document.body.style.overflow = "";
                            z_show.style.display = "none";
                            }
                            });
      initpage();

};

//获取星星
var pingjiabo=false;
function flXQgetStarNumberInHTML(flXQInfoStarArray,xjTotalWithPJ)
{
    var starJson = flXQInfoStarArray;
    if(starJson[0].countavg!=0){
        pingjiabo=true;
        $("#pingjia-div").attr("style","display:block")
        //     $("#boder-div").attr("style","display:block")
        if(starJson[0].countavg>1&&starJson[0].countavg<2){
            $("#stare").attr('src',"images/start-harftwo.png");
        }else if(starJson[0].countavg>2&&starJson[0].countavg<3){
            $("#stare").attr('src',"images/strart-harfthree.png");
            //     $("#stare").html('<span class="star7 active" _val=7 ></span>')
        }else if(starJson[0].countavg>3&&starJson[0].countavg<4){
            $("#stare").attr('src',"images/start-harfthree.png");
            //      $("#stare").html('<span class="star8 active" _val=8 ></span>')
        }else if(starJson[0].countavg>4&&starJson[0].countavg<5){
            $("#stare").attr('src',"images/start-harffour.png");
            //      $("#stare").html('<span class="star8 active" _val=9 ></span>')
        }else if(starJson[0].countavg==1){
            $("#stare").attr('src',"images/start-one.png");
            //       $("#stare").html('<span class="star'+Math.round(starJson[0].countavg)+' active" _val='+Math.round(starJson[0].countavg)+'></span>');
        }else if(starJson[0].countavg==2){
            $("#stare").attr('src',"images/start-two.png");
        }else if(starJson[0].countavg==3){
            $("#stare").attr('src',"images/start-three.png");
        }else if(starJson[0].countavg==4){
            $("#stare").attr('src',"images/start-four.png");
        }else if(starJson[0].countavg==5){
            $("#stare").attr('src',"images/start-five.png");
        }
    }else {
        $("#boder").attr("style","width:100%;height:6px;background-color:#e3e3e3");
        $("#pingjia-div").attr("style","display:none")
        $("#stare").html('<span class="star'+starJson[0].countavg+'" _val='+starJson[0].countavg+'></span>')
    }
    $("#pingjianum").html('<a class="pr-spot-desc2 free_dis2" href="judgelist.html" id="pingjianum">'+starJson[0].counts+'人评价&nbsp;></a>')
    $("#starCount").html(starJson[0].countavg);};

//获取助力者头像 列表信息
function flXQActivityhelpListInXQJS(zhuliTopicJson,xjTotalNumber,xj_UserType){
    var layout="";
    var topicJson=zhuliTopicJson;
//    alert('sdadasd');
    if(zhuliTopicJson!=null&&xjTotalNumber){
        $("#zhuliliebiao").attr("style","display:block");
        $("#ZLQnum").html("("+xjTotalNumber+"人)");
        for(var i=0;i<topicJson.length;i++){
        layout+='<li><img src="'+topicJson[i].avatar+'" alt=""/></li>'
        }
        if(xjTotalNumber!=0) {
            $("#zhuliqiangliebiao").html(layout);
        } else {
           
            $("#zhuliqiangliebiao").attr("style","display:none");
            $("#ZLQnum").attr("style","display:none");
        }
        
        
        var z_imgs = document.querySelectorAll(".z_portrait ul li img");
        var z_lis = document.querySelectorAll(".z_portrait ul li");
        var z_ul = document.querySelector(".z_portrait ul");
        var z_imagwidth = z_imgs[0].scrollWidth;
        /*取到轮播图宽度*/
        z_ul.style.width = (z_imagwidth+3) * z_imgs.length + "px";
        
        
        for(var i =0;i < z_lis.length;i++){
            z_lis[i].style.marginLeft = "3px";
        }
        
        /*父盒子*/
        var parentBox = document.querySelectorAll('.z_portrait')[0];
        /*子盒子*/
        var childBox = document.querySelectorAll('.z_portrait ul')[0];
        
        /*有两个区间  滑动区间  缓冲区间*/
        
        /*父容器的高度*/
        var parentW = parentBox.scrollWidth;
        /*子容器的高度*/
        var childW = childBox.scrollWidth;
        console.log(parentW);
        console.log(childW);
        /*定位区间 缓冲区间*/
        var maxPosition = 0;
        var minPosition = - (childW - document.body.scrollWidth);
        console.log(minPosition)
        
        var distance = 150;
        
        /*滑动区间*/
        var maxSwipe = maxPosition + distance;
        var minSwipe = minPosition - distance;
        
        /*公用方法*/
        /*定位*/
        var setTranslateX = function (translateY) {
            /*效率更高*/
            childBox.style.transform = 'translateX(' + translateY + 'px)';
            childBox.style.webkitTransform = 'translateX(' + translateY + 'px)';
        }
        /*加过渡*/
        var addTransition = function () {
            childBox.style.transition = 'all .2s ease';
            childBox.style.webkitTransition = 'all .2s ease';
        }
        /*清楚过渡*/
        var removeTransition = function () {
            childBox.style.transition = 'none';
            childBox.style.webkitTransition = 'none';
        }
        
        /*滑动*/
        var startX = 0;
        /*开始Y坐标*/
        var moveX = 0;
        /*滑动时候的Y坐标*/
        var distanceX = 0;
        /*滑动的距离*/
        /*记录当前的定位*/
        var currX = 0;
        var ll = 0;
        
        //记录元素的总宽度
        var z_imgWidth = z_imgs.length * z_imgs[0].offsetWidth + (z_imgs.length * 3);
        childBox.addEventListener('touchstart', function (e) {
                                  if(document.body.offsetWidth < z_imgWidth){
                                  e.preventDefault();
                                  startX = e.touches[0].clientX;
                                  }
                                  });
        childBox.addEventListener('touchmove', function (e) {
                                  if(document.body.offsetWidth < z_imgWidth){
                                  moveX = e.touches[0].clientX;
                                  distanceX = moveX - startX;
                                  removeTransition();
                                  setTranslateX(currX + distanceX);
                                  }
                                  });
        childBox.addEventListener('touchend', function () {
                                  if(document.body.offsetWidth < z_imgWidth){
                                  /*计算 当前滑动结束之后的位置*/
                                  currX = currX + distanceX;
                                  console.log(currX)
                                  if (currX > maxPosition) {
                                  currX = maxPosition;
                                  addTransition();
                                  setTranslateX(currX);
                                  } else if (currX < minPosition) {
                                  currX = minPosition;
                                  addTransition();
                                  setTranslateX(currX);
                                  }
                                  
                                  /*重置记录的参数*/
                                  startX = 0;
                                  moveX = 0;
                                  distanceX = 0;
                                  }
                                  });
        
        
      
        
        
        function transitionEnd(objDom, callback) {
            if (typeof objDom != 'object') {
                return false;
            }
            objDom.addEventListener('transitionEnd', function () {
                                    /*if(callback){
                                     callback();
                                     }*/
                                    callback && callback();
                                    });
            objDom.addEventListener('webkitTransitionEnd', function () {
                                    callback && callback();
                                    });
        }
        if(xj_UserType=="comp"){
            //如果是 商家号 nothing
        } else {
            $("#ZLQnum").click(function(){
                               if(zhuliTopicJson[0].receiveType=="ZHULIQIANG") {
                               window.location.href = "zhuliqiang.html";
                               FLMethodXQModel.flgetZhuliListInXQJS();
                               } else {
                               window.location.href = "canyulist.html";
                               }
                               });
            $(".z_portrait").click(function(){
                                          if(zhuliTopicJson[0].receiveType=="ZHULIQIANG") {
                                          window.location.href = "zhuliqiang.html";
                                          FLMethodXQModel.flgetZhuliListInXQJS();
                                          } else {
                                          window.location.href = "canyulist.html";
                                          }
                                          });
            //点击助力抢列表
            $("#zhuliliebiao").click(function(){
                                     if(zhuliTopicJson[0].receiveType=="ZHULIQIANG") {
                                     window.location.href = "zhuliqiang.html";
                                     FLMethodXQModel.flgetZhuliListInXQJS();
                                     } else {
                                     window.location.href = "canyulist.html";
                                     }
                                     });
        }
    } else {
        $("#zhuliliebiao").attr("style","display:none");
        $("#ZLQnum").attr("style","display:none");
    }
};

//评论
function flXQActivityjudgePLListInXQJS(commentJson,xjPLTotalNumber){
    var pinglunlayout="";
    var pinglunJson=commentJson;
    $("#comment-zero").empty();
    if(pinglunJson!=null&&pinglunJson!=""){
        pinglunlayout+='<div class="pr-container">'
        pinglunlayout+='<div style="padding-top:10px;">'
        pinglunlayout+='<div class="title-ico"> </div>'
        pinglunlayout+='<span class="free_dis0" > 评论<b style="float:right;color: #9d9d9d;font-weight: normal;font-size:12px;margin-right:-4px;">('+xjPLTotalNumber+'条) </b></span>'
        pinglunlayout+='</div>'
        for(var i=0;i<pinglunJson.length;i++){
            if(i<=4){
                pinglunlayout+='<div class="pr-container" style="border-bottom:1px solid #e3e3e3; padding-bottom: 0px;">'
                pinglunlayout+='<div class="user-pinglun"  onclick="commentIdd(\''+pinglunJson[i].nickname+'\',\''+pinglunJson[i].avatar+'\',\''+pinglunJson[i].createTime+'\',\''+pinglunJson[i].content+'\',\''+pinglunJson[i].commentId+'\')" style="padding: 10px 0 8px 0;">'
                pinglunlayout+='<img src="'+BaseUrl+pinglunJson[i].avatar+'" width="56" height="56" >'
                pinglunlayout+='<div class="head-name">'
                pinglunlayout+='<div class="replay-btn4"><p style="margin-left: 20px;margin-top: -2px;font-size: 12px;color: #6f6f6f;">'+pinglunJson[i].replies+'</p></div>'
                pinglunlayout+='<p >'+pinglunJson[i].nickname+'</p>'
                pinglunlayout+='<p style="color:#d3d3d3;">'+pinglunJson[i].createTime+'</p>'
                pinglunlayout+='<p  style="word-wrap:break-word;">'+pinglunJson[i].content+'</p>'
                pinglunlayout+='</div>'
                pinglunlayout+='</div>'
                pinglunlayout+='<div class="pinglun-container">'
                pinglunlayout+='</div>'
                pinglunlayout+='<div>'
                pinglunlayout+='</div>'
                pinglunlayout+='</div>'
            }
        }
        pinglunlayout+='<div class="lookpinglun" style="border-top:0px solid #e3e3e3;">'
        pinglunlayout+='<a class="pr-spot-desc4 free_dis19 "style="display:block;width: 34%;margin: 0 auto;margin-top:10px;margin-bottom: 10px;" onclick="morecomment()">查看全部评论</a>'
        pinglunlayout+='</div>'
        pinglunlayout+='<div style="font-size:10px;color:#e3e3e3;text-align:center;">本活动由免费啦提供，与Apple Inc.无关</div>'
        $("#comment-zero").html(pinglunlayout);
    } else {
        pinglunlayout+='<div style="font-size:10px;color:#e3e3e3;text-align:center;">本活动由免费啦提供，与Apple Inc.无关</div>'
        $("#comment-zero").html(pinglunlayout);
    }
    if(xjPLTotalNumber==""){
        $("#commentnum").html("评论(0)");
    }else{
        $("#commentnum").html("评论("+xjPLTotalNumber+")");
    }
};


// 回复评论
function commentIdd(name,tupian,time,content,cetId){
    window.location.href="replayListH5.html";
//    window.details.commentId(name,tupian,time,content,cetId);
    FLMethodXQModel.takeParmToNextPgeNameImageTimeContentCetID(name,tupian,time,content,cetId);
};
//查看所有评论
function morecomment(){
    window.location.href="commentListH5.html";
}

//关注成功，可以领取
function fltakeCareSuccessAndPick()
{
    if( flXQInfoModel.topicConditionKey=="GUANZHULING"){
        $("#receive").html('领取');
         FLMethodXQModel.flinsertParticipate(); //插入参与记录
//        $('#receive').click(function(){
//                            alert('sads');
//                            FLMethodXQModel.saveTopicWithNoneInfo; //点击可以领取
//                            });
    }
}

function checkCanPickUpTopic()
{
//    alert('12');
    
};
 
function getTopicPic()
{
    
};

//评论列表
function goToJudgeListPage()
{
    
};

//小数点保留两位
function changeTwoDecimal(x)
{
    var f_x = parseFloat(x);
    if (isNaN(f_x))
    {
        alert('function:changeTwoDecimal->parameter error');
        return false;
    }
    f_x = Math.round(f_x *100)/100;
    return f_x;
};

function flXQGoToPartInfoPage()
{
//    alert(flXQInfoModel.partInfo);
    $("#receive").click(function(){
                          window.location.href="addreciveinfo.html";
                        FLMethodXQModel.getPickPartInfoInHTML();
                      
                        });
};
//message
function flXQSetTopicMessageInHTML(flTopicMessage)
{
//    alert(flTopicMessage[0].description);  //description
//    $("#pubnum").html('发布：<i>'+flTopicMessage[0].num+'</i>');
//    $("#pubpv").html('热度：<i>'+flTopicMessage[0].pvNum+'</i>');
//    //设置一句话描述
//    $("#publisher-discribe").html(flTopicMessage[0].description);
    if(flTopicMessage[0].description!=null){
        if(flTopicMessage[0].description.length>10) {
            $("#publisher-discribe").html(flTopicMessage[0].description.substr(0,10)+"...");
        } else {
            $("#publisher-discribe").html(flTopicMessage[0].description);
        }
    }else if(flTopicMessage[0].description==null||flTopicMessage[0].description==""){
        $("#publisher-discribe").html("");
    }
    $("#pubnum").html(flTopicMessage[0].num);
    $("#pubpv").html(flTopicMessage[0].pvNum);
};

//判断是否商家号

function flIsBusAccountTypeAction() {
//    alert(flXQacctype);
//    if(flXQacctype=="comp") {
        $("#receive").attr("style","display:none");
        $("#footer").attr("style","display:none");
        $("#comp_look").attr("style","display:none");
//    }
};

function xjBeProhibitEd(){
    $("#footer").attr("style","display:none");
//    alert('账户处于非正常状态，请联系管理员');
}


//判断是否有领取资格
var commandName = 'xjAlertInfoWithStr'; //用来alert 的方法
var commandNameAndPushToBilnd = 'xjAlertAndPushToBilnd'; //alert 后push 到绑定手机号
function flXQreceivezige(reMessageData,isPersonalComeIn) {
//    var ifGet=false;//是否有领取资格
    var ifJoin=false;//助力抢是否参与
    var xj_check_receive = reMessageData;
    
    if(flXQInfoModel.isPhNum==1) {
        if(reMessageData.success && flXQInfoModel.partInfo && flXQInfoModel.partInfo!=""){
            flXQGoToPartInfoPage();
            return;
        } else if(flXQInfoModel.topicConditionKey=="SUIXINLING") {
            if(!reMessageData.success) {
                $("#receive").html(reMessageData.msg);
            } else {
                $("#receive").html("前往领取");
                $("#receive").click(function(){
                                    location.href="nima://FLFLHTMLHTMLsaveTopicClickOn";  //领取
                                    });
            }
        } else if (flXQInfoModel.topicConditionKey=="ZHULIQIANG") {
//                      alert(reMessageData.msg);
//            $("#zhuliliebiao").attr("style","display:block");
            if(!reMessageData.success) {
                if (reMessageData.buttonKey=="b17") {
                    $("#receive").html("继续参与");
                    $("#zhuliliebiao").attr("style","display:block");
                    //转发
                    $("#receive").click(function(){
                                        //调起转发
                                        location.href="nima://zhuanfaAndCanyuWithContinueZhuli";
                                        });
                    $("#zhuliliebiao").click(function(){
                                             ifJoin = true;
                                             window.location.href="zhuliqiang.html";
                                             });
                } else if (reMessageData.buttonKey=="b16"){
                    $("#hahahaha").html('<span><a class="pr-spot-desc4 free_dis5" id="receive" onclick="participateId()">立即参与</a></span>');
                    $("#zhuliliebiao").click(function(){
                                             ifJoin = true;
                                             location.href="zhuliqiang.html";   //zhuliqiang.html
                                             });
                    $("#receive").click(function(){
                                        //调起转发
                                        location.href="nima://xjPushZLQHTMLPageAndAlert";
                                        });
                    
                } else if (reMessageData.buttonKey=="b20"){
                    $("#hahahaha").html('<span><a class="pr-spot-desc4 free_dis5" id="receive">继续参与</a></span>');
                    $("#zhuliliebiao").click(function(){
                                             ifJoin = true;
                                             window.location.href="zhuliqiang.html";
                                             });
                    
                } else if (reMessageData.buttonKey=="b21"){
                    $("#hahahaha").html('<span><a class="pr-spot-desc4 free_dis5" id="receive">继续参与</a></span>');
                    $("#zhuliliebiao").click(function(){
                                             ifJoin = true;
                                             window.location.href="zhuliqiang.html";
                                             });
                    
                } else if (reMessageData.buttonKey=="b18"){
                    $("#hahahaha").html('<span><a class="pr-spot-desc4 free_dis5" id="receive" onclick="participateId()">继续参与</a></span>');
                    $("#zhuliliebiao").click(function(){
                                             ifJoin = true;
                                             window.location.href="zhuliqiang.html";
                                             });
                    
                }else if (reMessageData.buttonKey=="b19"){
                    $("#hahahaha").html('<span><a class="pr-spot-desc4 free_dis5" id="receive" onclick="participateId()">继续参与</a></span>');
                    $("#zhuliliebiao").click(function(){
                                             ifJoin = true;
                                             window.location.href="zhuliqiang.html";
                                             });
                    
                } else if (reMessageData.buttonKey=="b10"){
                    $("#receive").html("已领取");
                    $("#zhuliliebiao").attr("style","display:block");
                    $("#zhuliliebiao").click(function(){
                                             ifJoin = true;
                                             window.location.href="zhuliqiang.html";
                                             });
                } else if (reMessageData.buttonKey=="b6"){
                 $("#receive").html(reMessageData.msg);
                } else {
                    $("#receive").html(reMessageData.msg);
                    //调起转发+
                    $("#receive").click(function(){
                                        //调起转发
                                        location.href="nima://zhuanfaAndCanyu";
                                        });
                }
            } else {
                //             alert(reMessageData.msg);
                $("#zhuliliebiao").attr("style","display:block");
                $("#receive").click(function(){
                                    location.href="nima://FLFLHTMLHTMLsaveTopicClickOn";  //领取
                                    });
            }
        } else if (flXQInfoModel.topicConditionKey=="GUANZHULING") {
            if(!reMessageData.success) {
                $("#receive").html(reMessageData.msg);
                if(reMessageData.msg=="抢光了"){
                    $("#receive").click(function(){
                                        location.href = 'js-call:' + commandName + ':' + encodeURIComponent("哎呀来晚啦，下次要早点儿哦~");
                                        });
                } else if (reMessageData.buttonKey=="b12") {
                    $("#receive").html("立即参与");
                    $("#receive").click(function(){
                                        //关注并参与
                                        location.href="nima://xjHTMLCareAndPartIn";
                                        });
                }
            } else {
                $("#receive").click(function(){
//                                    alert('s');
                                    location.href="nima://xjHTMLPickUpAndPartIn";  //领取并参与
                                    });
            }
            
        } else if (flXQInfoModel.topicConditionKey=="ZHUANFALING") {
            if(!reMessageData.success) {
                $("#receive").html(reMessageData.msg);
                if(reMessageData.buttonKey=="b15") {   //可领取不可转发
                    fllfJSActionPick();  //领取
                } else if(reMessageData.buttonKey=="b14") {   //可转发不可领取
                    $("#receive").html("立即参与");
                    $("#receive").click(function(){
                                        //调起转发
                                        location.href="nima://xjAlertZHUANFALING";
                                        //                                    FLMethodXQModel.flpickTypeRelayInXQJS();
                                        });
                } else if(reMessageData.data==3) {   //既不可以领取也不可以转发
                    $("#receive").html(reMessageData.msg);
                }
            } else {
                $("#receive").html("前往领取");
                fllfJSActionPick();  //领取
            }
        }
    }
    if (!reMessageData.success) {
//        switch(true){
//            case reMessageData.buttonKey=="b22":
//                
//                break;
//            case reMessageData.buttonKey=="b2":
//                
//                break;
//            default:
//                break;
//        }
        if (reMessageData.buttonKey=="b22"){
            $("#hahahaha").html('<span><a class="pr-spot-desc4 free_dis5" id="receive">不能领取</a></span>');
            $("#zhuliliebiao").click(function(){
                                     ifJoin = true;
                                     window.location.href="zhuliqiang.html";
                                     });
            $("#receive").click(function(){
                                //关注并参与
                                location.href="nima://xjHTMLCareAndPartIn";
                                });
        } else if (reMessageData.buttonKey=="b2"){ //b2：请绑定手机号
            $("#receive").html("立即参与");
            $("#zhuliliebiao").click(function(){
                                     ifJoin = true;
                                     window.location.href="zhuliqiang.html";
                                     });
            $("#receive").click(function(){
                                //绑定手机     commandNameAndPushToBilnd
                                location.href = "nima://xjBlindYourPhoneNumber";
                                });
        }  else if(reMessageData.buttonKey=="b8"){
            $("#receive").html("已结束");
            $("#receive").click(function(){
                                location.href = 'js-call:' + commandName + ':' + encodeURIComponent("哎呀来晚啦，下次要早点儿哦~");
                                });
        } else  if(reMessageData.buttonKey=="b5"){
            $("#receive").html("已结束");
            $("#receive").click(function(){
                                location.href = 'js-call:' + commandName + ':' + encodeURIComponent("哎呀来晚啦，下次要早点儿哦~");
                                });
        } else  if(reMessageData.buttonKey=="b4"){
            $("#receive").html("发布者不能领取");
        } else  if(reMessageData.buttonKey=="b6"){
            $("#receive").html("已抢光");
            $("#receive").click(function(){
                                location.href = 'js-call:' + commandName + ':' + encodeURIComponent("哎呀来晚啦，下次要早点儿哦~");
                                });
        } else  if(reMessageData.buttonKey=="b7"){ //活动未开始  请耐心等待表捉急哦~
            $("#receive").html("活动未开始");
            $("#receive").click(function(){
                                location.href = 'js-call:' + commandName + ':' + encodeURIComponent("请耐心等待表捉急哦~");
                                });
        } else  if(reMessageData.buttonKey=="b9"){
            $("#receive").html("立即参与");
        } else  if(reMessageData.buttonKey=="b10"){
            $("#receive").html("已领取");
            $("#receive").click(function(){
                                location.href = 'js-call:' + commandName + ':' + encodeURIComponent("呃，你已经领取过了呢不要太贪心哦~");
                                });
        } else  if(reMessageData.buttonKey=="b13"){
            $("#receive").html("已领取");
            $("#receive").click(function(){
                                location.href = 'js-call:' + commandName + ':' + encodeURIComponent("呵呵，今天已经到上限了呢，明天早点儿来哦~");
                                });
        } else  if(reMessageData.buttonKey=="b21"){
            $("#receive").html("立即参与");
            $("#receive").click(function(){
                                location.href = 'js-call:' + commandName + ':' + encodeURIComponent("您不在领取范围内，去看看其他活动吧");
                                });
        } else  if(reMessageData.buttonKey=="b1"){
            $("#receive").html("立即参与");
            $("#receive").click(function(){
                                location.href = 'js-call:' + commandName + ':' + encodeURIComponent("参数错误");
                                });
        }
    }
    
};

/**
 *显示隐藏的助力抢用户头像
 **/
function participateId(){
    //       window.details.inSertCanYu();
 
//    FLMethodXQModel.flinsertParticipate();  //插入参与记录
//    alert('调用此方法');
    //判断是否可以领取
//    if(!ifJoin){
//        window.details.receiveInfo();       //获取不能领取原因
//        window.details.showZhuLiQiang();    //查看活动助力列表
//        window.details.zhulitopicqiang();     //获取活动助力抢列表信息
        $("#zhuliliebiao").attr("style","display:block");
    location.href="nima://xjInitiateHelpAndRealy";
//       FLMethodXQModel.flpickTypeRelayInXQJS();       //转发  调用此方法会导致崩溃￥￥￥
//    }
};

/**
 *领取
 **/

function fllfJSActionPick(){
    $("#receive").click(function(){
                        location.href="nima://FLFLHTMLHTMLsaveTopicClickOn";  //领取
                        });
};

//判断是否收藏
var xjCollectionOrNot="";
function flXQisAlreadyCollectionInHTML(isAlreadyCollection) {
    if(isAlreadyCollection) {
//        alert(isAlreadyCollection);
        $("#shoucang_src").attr("src","images/collect_light.png");
//        $("#shoucang").html('<img src="images/collect_light.png" style="width: 24px;height: 24px;position: absolute;top: 5px;left: 34px;">');
           xjCollectionOrNot = true;

    }else{
//        $("#shoucang").html('<img src="images/collect.png" style="width: 24px;height: 24px;position: absolute;top: 5px;left: 34px;">');
        $("#shoucang_src").attr("src","images/collect.png");

        xjCollectionOrNot = false;

    }
};
var xj_isFriend="";
function xjIsFriendOrNot(checkFocus){
    xj_isFriend = checkFocus;
    if(checkFocus){
        $("#comp_look").attr("src","images/Love.png");
        $("#guanzhustate").html("已关注");
        if(flXQInfoModel.topicConditionKey=="GUANZHULING"){
//            if(flXQInfoModel.partInfo){
//                flXQGoToPartInfoPage();
//                return;
//            }
//            if(xj_check_receive.success){
//                $("#receive").html("前往领取");
//                $("#receive").click(function(){
//                                    //领取并参与
//                                    location.href="nima://xjHTMLPickUpAndPartIn";
//                                    });
//            } else {
//                $("#receive").html(xj_check_receive.msg);
//            }
           
        }
    }else if(!checkFocus){
        $("#comp_look").attr("src","images/love-hui.png");
        $("#guanzhustate").html("关注");

//        //关注领
//        $("#comp_look").click(function(){
////                               location.href = 'xjAddFriendAndRefresh';
//                              });
//        if(flXQInfoModel.topicConditionKey=="GUANZHULING"){
//            $("#receive").html("立即参与");
//            $("#receive").click(function(){
//                                //关注并参与
//                                location.href="nima://xjHTMLCareAndPartIn";
//                                });
//        }
    }
//    if(!flXQInfoModel.isPhNum) {
//        $("#receive").html("请绑定手机号");
//        $("#receive").click(function(){
//                            location.href ="nima://xjBlindYourPhoneNumber";
//                            });
//        return;
//    }
};

function xjIsMySelfTopic(xjUserId,xjAccountType){
    if(xjUserId == flXQInfoModel.userId && xjAccountType==flXQInfoModel.userType) {
//        alert('yes');
        $("#comp_look").attr("style","display:none");
        $("#footer").attr("style","display:none");
    }
    
};

function xjJBActionToHref(){
    window.location.href="jubao.html";
}
var xj_isPushIn = true;
function xjgowhere(xjPushState) {
    if(xj_isPushIn){
        if(xjPushState == 1) { //1为助力抢
           window.location.href = "zhuliqiang.html";
        } else if(xjPushState == 2) { //2为评论
          window.location.href="replayListH5.html";
        }
        
    }
};
function xjmeishenmeyong() {
    window.location.href = "xiangqing.html";
}

function xjPushPushZLQPage() {
//     window.location.href="zhuliqiang.html";
}
//判断屏幕是不是5
function xj_is_Screen_5(xj_screen_width){
//     alert(xj_screen_width);
    xj_is_screen_width_5 = xj_screen_width;
    
    if(xj_screen_width=="i_5") {
        $("#pinglun-2").html('<img src="images/comment_icon.png" style="width: 22px;height: 22px;position: absolute;top: 5px;left: 32px;">');
        $("#fenxiang").html('<img src="images/share_icon.png" style="width: 24px;height: 24px;position: absolute;top: 5px;left: 28px;">');
        if(xjCollectionOrNot){
            $("#shoucang").html('<img src="images/collect_light.png" style="width: 24px;height: 24px;position: absolute;top: 5px;left: 28px;">');
        }else{
            $("#shoucang").html('<img src="images/collect.png" style="width: 24px;height: 24px;position: absolute;top: 5px;left: 28px;">');
        }

    } else if(xj_screen_width=="i_6") {
      
    } else {
        $("#pinglun-2").html('<img src="images/comment_icon.png" style="width: 22px;height: 22px;position: absolute;top: 5px;left: 40px;">');
        $("#fenxiang").html('<img src="images/share_icon.png" style="width: 24px;height: 24px;position: absolute;top: 5px;left: 39px;">');
        if(xjCollectionOrNot){
            $("#shoucang").html('<img src="images/collect_light.png" style="width: 24px;height: 24px;position: absolute;top: 5px;left: 38px;">');
        }else{
            $("#shoucang").html('<img src="images/collect.png" style="width: 24px;height: 24px;position: absolute;top: 5px;left: 38px;">');
        }
    }
}

//function flXQgetDeatilsInHTML(jsonDate){
//    //            alert(jsonDate.details);
////    $("#tuwen").html(jsonDate.details);
//    $("#tuwen").html(flXQInfoModel.details);
//};


/*
 address = "\U5317\U4eac\U5e02\U897f\U57ce\U533a\U91d1\U878d\U8857\U8857\U9053\U95f9\U5e02\U53e3\U5927\U885715\U53f7";
 assiNum = 0;
 commentCount = 0;
 createTime = "2016-01-20 09:30:19";
 creator = 3;
 detailchart = "1453083838689.jpg";
 details = "<p><img src=\"/resources/static/topic/comp/1/14530838200673.jpg\" title=\"\" alt=\"14530838200673.jpg\" width=\"200px\"/></p>";
 enable = 0;
 endTime = "2016-01-26 00:00:00";
 favNum = 0;
 invalidTime = "2016-02-06 00:00:00";
 latitude = "39.931577";
 longitude = "116.344123";
 lowestNum = "";
 newDate = "2016-01-21 16:08:44";
 operType = 0;
 partInfo = POSITION;
 pv = 0;
 rankCount = 0;
 receiveNum = 0;
 rule = "\U65e0\U9650\U5236";
 ruleTimes = "";
 startTime = "2016-01-20 09:29:00";
 state = 1;
 thumbnail = "1453253392400.jpg";
 topicCondition = "\U5173\U6ce8\U9886--\U5fc5\U987b\U5173\U6ce8\U6210\U529f\U540e\U624d\U53ef\U4ee5\U9886\U53d6";
 topicConditionKey = GUANZHULING;
 topicExplain = 12;
 topicId = 157;
 topicNum = 1000;
 topicPrice = "123.55";
 topicRange = "\U516c\U5f00";
 topicTag = "\U7279\U8272\U7f8e\U98df";
 topicTheme = "1.20-\U5173\U6ce8\U9886-\U65e0\U9650\U5236";
 topicType = FREE;
 transformNum = 0;
 url = "";
 useNum = 0;
 userId = 1;
 userType = comp;
 uv = 0;
 zlqRule = null;
 
 
 b1：参数错误
 b2：请绑定手机号
 b3: 用户参数错误
 b4: 发布者不能领取
 b5: 活动已下架
 b6: 抢光了
 b7: 活动未开始
 b8: 活动已结束
 b9: 您没有参与活动
 b10:您已经领取过了
 b11:可以领取
 b12:需要关注才能领取
 b13:今天已达到上限
 b14:可转发不可领取
 b15:可领取不可转发
 b16:请发起助力后才能领取
 b17:请继续发起助力
 b18:您不满足先到先得条件，不能领取
 b19:助力还未结束哦
 b20:您不在排名中,不能领取
 b21:您不在领取范围内,不能领取
 b22:您和发布者非好友,不能领取
 b23:
 */



