//var BaseUrl = "http://192.168.20.53:8080";
//var BaseUrl = "http://59.108.126.36:8585";
//var BaseUrl = "http://59.108.126.36:8888";
var BaseUrl  ="";   //freela
var UserId="";
var UserPerId="";
var xj_Is_H5_Page=false;

$(document).ready(function(){
//window.details.zhulitopicqiang();
//                  alert('sad');
//                  $('.t6')
            
                  $("#watchMine").click(function(){
//                                      window.location.href="zhuliqianglist.html";
//                                        var commandName = 'xjGotoMyPersonalHelpPage';
                                        //                            alert(encodeURIComponent(JSON.stringify(jsonStr)));
//                                        location.href = 'js-call:' + commandName + ':' + encodeURIComponent(JSON.stringify(DetailsJson.participateId));
//                                        alert(DetailsJson.nickname);
                                        participateId(DetailsJson.participateId,DetailsJson.nickname);
                                        });
                  $("#sousuo").click(function(){
                                        var searchNick = $("#findHelper").val();
                                        if(searchNick!=null){
                                        var commandName = 'xjSearchHTMLDetailsByCommentIdWithNickName';
                                        location.href = 'js-call:' + commandName + ':' + encodeURIComponent(searchNick);
                                     }
                                     });
                  //点击 助力数 事件
                  $("#receiveNum").click(function() {
                                   location.href = "nima://xjclicktopushselfhelplist";
                                   });
                  //滑动到底部的监听
                  $(window).scroll(function(){
                                   　　var scrollTop = $(this).scrollTop();
                                   　　var scrollHeight = $(document).height();
                                   　　var windowHeight = $(this).height();
                                   　　if(scrollTop + windowHeight == scrollHeight){
//                                   location.href = "nima://xjLoadMoreHelpListInHTML";
                                   location.href = 'js-call:' + 'xjLoadMoreHelpListInHtmlZlq' + ':' + encodeURIComponent(xj_current_page);
                                   
                                   　　}
                                   });
                  
                  
});

//function flXQActivityhelpListInXQJS(zhuliTopicJson)
var DetailsJson="";
var totalNum="";
var getPnum="";
var rank ="";
var isdate = false;//活动是否结束
var notdate =false;//活动是否开始
var isbussess="";//是不是商家
var patipateNum="";//参与人数
var isget ="";
var xj_current_page=""; //当前页
var xj_zlq_pagesize=20;

function xjSetZLQPageIsgetInfo(xj_is_get_dic){
//    alert(xj_is_get_dic.buttonKey);
    if(xj_is_get_dic.buttonKey=="b10"){
        isget=true;
    } else {
        isget=false;
    }
};

function topiczhuliqiangInZhuliqiangJS(zhuliTopicJson,UserId) {
    if(zhuliTopicJson!=null){
        var layout="";
        var topicJson=zhuliTopicJson;
        
        if(zhuliTopicJson.length >= xj_zlq_pagesize) {
            xj_current_page = zhuliTopicJson.length / xj_zlq_pagesize;
        
        }
        
        var xj_is_partIn =false; //我是否参与了
        for(var i=0;i<topicJson.length;i++){
           
//            if(topicJson[i].userId==UserId){
//         
//                $("#rank").html(topicJson[i].rank);
//                rank=topicJson[i].rank;
//                
//                if(DetailsJson.zlqRule=="TOP"&&!isdate){
//                    if(parseInt(DetailsJson.lowestNum)>getPnum){
//                        var chaNum=DetailsJson.lowestNum-getPnum;
//                        $("#whyreceive").html("还差"+chaNum+"个助力才有资格，拼颜值的时候到了");
//                    }else if(parseInt(DetailsJson.lowestNum)<=getPnum&&rank<=totalNum&&!isget){
//                        $("#whyreceive").html("人气爆棚的你，赶快去领取福利吧！");
//                    }else if(parseInt(DetailsJson.lowestNum)<=getPnum&&rank<=totalNum&&isget){
//                        $("#whyreceive").html("您已经领取过了~不要太贪心哈=-=");
//                    }else{
//                        $("#whyreceive").html("想要得到它吗？PK掉其他人吧！");
//                    }
//                }else if(DetailsJson.zlqRule=="TOP"&&isdate){
//                    if(parseInt(DetailsJson.lowestNum)>getPnum){
//                        $("#whyreceive").html("明明可以靠脸吃饭，却偏偏要靠实力/(ㄒoㄒ)/~");
//                    }else if(parseInt(DetailsJson.lowestNum)<=getPnum&&rank<=totalNum){
//                        $("#whyreceive").html("人气爆棚的你，赶快去领取福利吧！");
//                    }else{
//                        $("#whyreceive").html("这次被别人反超了，下次活动一定要拿下它！");
//                    }
//                }
//                else{
//                    if(parseInt(DetailsJson.lowestNum)>getPnum){
//                        var chaNum=DetailsJson.lowestNum-getPnum;
//                        $("#whyreceive").html("还差"+chaNum+"个助力才能领取，转发到更多地方请求好友助力吧！");
//                    }else if(DetailsJson.lowestNum<=getPnum&&rank<=totalNum){
//                     
//                        $("#whyreceive").html("天下武功唯快不破！恭喜你达到领取资格！");
//                    }else{
//                      
//                        $("#whyreceive").html("先下手为强，后下手遭殃，下次快点吧");
//                    }
//                }
//            
//                xj_is_partIn = true;
//            }

            if (parseInt(DetailsJson.lowestNum) <= parseInt(topicJson[i].num)) {
                layout += '<div class="can_lun" id="paricpate_' + topicJson[i].participateId + '">'
                if ((i + 1) <= DetailsJson.topicNum) {
                    layout += '<h1>' + (i + 1) + '</h1>'
                } else {
                    layout += '<h1 style="color:#2d2d2d">' + (i + 1) + '</h1>'
                }
                layout += '<div class="box_1">'
                layout += '<div style="width: 46px;height: 46px;border-radius: 46px;overflow: hidden;background-size: contain;float: left;">'
                layout += '<img src="' + BaseUrl + topicJson[i].avatar + '" alt="" style="float: left;width:46px;height: 46px;" onclick="participateId(' + topicJson[i].participateId + ',\'' + topicJson[i].nickname + '\')">'
                layout += '</div>'
                layout += ' <div class="can_lun2"  id="pomote'+topicJson[i].participateId+'" onclick="participateId(' + topicJson[i].participateId + ',\'' + topicJson[i].nickname + '\')">'
                layout += ' <span class="span_1">' + topicJson[i].nickname + '</span>'
                if (DetailsJson.zlqRule == "TOP") {
                    if(topicJson[i].promateTime) {
                         layout += '<h2 class="can_date">最后助力:' +  topicJson[i].promateTime.substring(5)  + '</h2>'
                    } else {
                         layout += '<h2 class="can_date">最后助力:' +  '没有时间' + '</h2>'
                    }
                } else {
                    if(topicJson[i].lockTime){
                       layout += '<h2 class="can_date">达到时间:' +  topicJson[i].lockTime.substring(5)+ '</h2>'
                    } else {
                       layout += '<h2 class="can_date">达到时间:' +   '没有时间'+ '</h2>'
                    }
                }
                layout += '</div>'
                if (topicJson[i].ispromote) {
                    layout += '<div class="bb"  onclick="dianzan(' + topicJson[i].participateId + ',\'' + topicJson[i].num + '\',' + topicJson[i].ispromote + ')"><img src="images/zan-ico.png"></div>'
                } else {
                    layout += '<div class="bb" onclick="dianzan(' + topicJson[i].participateId + ',\'' + topicJson[i].num + '\',' + topicJson[i].ispromote + ')"><img src="images/zan-ico-gray.png"></div>'
                }
                if ((i + 1) <= DetailsJson.topicNum) {
                    layout += '<div class="cc"  onclick="participateId(' + topicJson[i].participateId + ',\'' + topicJson[i].nickname + '\')"   id="dianzan'+topicJson[i].participateId+'" style="color: #f87d7b">' + topicJson[i].num + '</div>'
                } else {
                    layout += '<div class="cc"   onclick="participateId(' + topicJson[i].participateId + ',\'' + topicJson[i].nickname + '\')"   id="dianzan'+topicJson[i].participateId+'">' + topicJson[i].num + '</div>'
                }
                layout += '</div>'
                layout += '</div>'
            } else {
                layout += '<div class="can_lun" id="paricpate_' + topicJson[i].participateId + '">'
                layout += '<h1 style="color:#2d2d2d;">' + (i + 1) + '</h1>'
                layout += '<div class="box_1" >'
                layout += '<div style="width: 46px;height: 46px;border-radius:46px;overflow: hidden;background-size: contain;float: left;">'
                layout += '<img src="' + BaseUrl + topicJson[i].avatar + '" alt="" style="float: left;width:46px;height:46px;" onclick="participateId(' + topicJson[i].participateId + ',\'' + topicJson[i].nickname + '\')">'
                layout += '</div>'
                layout += ' <div class="can_lun2" onclick="participateId(' + topicJson[i].participateId + ',\'' + topicJson[i].nickname + '\')">'
                layout += ' <span class="span_1">' + topicJson[i].nickname + '</span>'
                if (DetailsJson.zlqRule == "TOP" && topicJson[i].num > 0) {
                    if(topicJson[i].promateTime){
                      layout += '<h2 class="can_date">最后助力:' +  topicJson[i].promateTime.substring(5) + '</h2>'
                    } else {
                       layout += '<h2 class="can_date">最后助力:' +  '没有时间' + '</h2>'
                    }
                }
                layout += '</div>'
                if (topicJson[i].ispromote) {
                    layout += '<div class="bb" id="pomote'+topicJson[i].participateId+'"  onclick="dianzan(' + topicJson[i].participateId + ',\'' + topicJson[i].num + '\',' + topicJson[i].ispromote + ')"><img src="images/zan-ico.png" ></div>'
                } else {
                    layout += '<div class="bb"  id="pomote'+topicJson[i].participateId+'" onclick="dianzan(' + topicJson[i].participateId + ',\'' + topicJson[i].num + '\',' + topicJson[i].ispromote + ')"><img src="images/zan-ico-gray.png"></div>'
                }
                layout += '<div class="cc" onclick="participateId(' + topicJson[i].participateId + ',\'' + topicJson[i].nickname + '\')" id="dianzan'+topicJson[i].participateId+'">' + topicJson[i].num + '</div>'
                layout += '</div>'
                layout += '</div>'
            }
        }
        $("#goperzhuli").html(layout);
       }
}

function participateId(id,nickname){
//    alert(id);
    window.location.href="zhuliqianglist.html";
//    FLMethodXQModel.participateIdInZhuliqiangJSNickname(id,nickname); //传给原生
    location.href='js-call' + ':' + 'xjPushPerZLQAndPassId'+ ':' + encodeURIComponent(id+','+nickname);
};
function xjPushPerZLQAndInitPage () {
     window.location.href="zhuliqianglist.html";
}

function dianzan(id,num,state){
//    alert(state);
    if(state == true){
//       alert(state);
        location.href = 'js-call:' + 'xjAlertInfoWithStr' + ':' + encodeURIComponent("您已助力，不能重复助力！");
    } else {
         location.href = 'js-call:' + 'FLFLHTMLActionPerZhuliqiangHelpClick' + ':' + encodeURIComponent(JSON.stringify(id));
        if(!isdate){
        // $("#dianzan"+id).html(num*1+1);
        //$("#pomote"+id).html('<img src="images/zan-ico.png" >');
        }
        layout = "";
    }
}

function xjZhuliqiangTotalNumberSet(xjToTalNumber)
{
//    alert(xjToTalNumber[0].howNum); //test/
    
};

function flGetJSXQInfomation(jsonDate) {
    
//    alert(jsonDate.lowestNum); //test
    jsonDate = jsonDate.data;
    DetailsJson=jsonDate;
    UserId=jsonDate.userId;
//    $("#topnum").html(jsonDate.lowestNum);
    $("#receiveNum").html(jsonDate.assiNum);
//    $("#totalNum").html(jsonDate.topicNum);
    totalNum = jsonDate.topicNum;
//    getPnum  = jsonDate.assiNum;
    
//    alert(getPnum);
//    alert(jsonDate.zlqRule);
    if(jsonDate.zlqRule=="FIRST"){
        $("#poorzl").html("最低助力数"+jsonDate.lowestNum+",先到先得");
    }else{
        $("#poorzl").html("最低助力数"+jsonDate.lowestNum+",Top领取");
    }
    
    if(parseInt(jsonDate.lowestNum)>parseInt(jsonDate.receiveNum)){
//        $("#multiple").html( parseInt(jsonDate.lowestNum)-parseInt(jsonDate.receiveNum));
    }else if(parseInt(jsonDate.lowestNum)<=parseInt(jsonDate.receiveNum)){
        $("#whyreceive").html("您达到了领取标准");
    }
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
        if(hours>=0&&hours<=9&&minutes>=0&&minutes<=9){
            $("#diff").html("距离活动结束还有"+days+"天"+"0"+hours+"时"+"0"+minutes+"分");
        }else if(hours>=0&&hours<=9&&minutes>9){
            $("#diff").html("距离活动结束还有"+days+"天"+"0"+hours+"时"+minutes+"分");
        }else if(hours>9&&minutes>=0&&minutes<=9){
            $("#diff").html("距离活动结束还有"+days+"天"+hours+"时"+"0"+minutes+"分");
        }else{
            $("#diff").html("距离活动结束还有"+days+"天"+hours+"时"+minutes+"分");
        }
    }
    else if(days<0){
        $("#diff").html("活动已结束");
    }else if(days==0&&hours>0&&minutes>=0){
        if(hours>0&&hours<=9&&minutes>=0&&minutes<=9){
            $("#diff").html("距离活动结束还有"+"0"+hours+"时"+"0"+minutes+"分");
        }else if(hours>0&&hours<=9&&minutes>9){
            $("#diff").html("距离活动结束还有"+"0"+hours+"时"+minutes+"分");
        }else if(hours>9&&minutes>=0&&minutes<=9){
            $("#diff").html("距离活动结束还有"+hours+"时"+"0"+minutes+"分");
        }else{
            $("#diff").html("距离活动结束还有"+hours+"时"+minutes+"分");
        }
    }else if(days==0&&hours==0&&minutes>=0){
        $("#diff").html("距离活动结束还有"+minutes+"分");
    }if(jsonDate.receiveNum==jsonDate.topicNum){
        $("#diff").html("活动已结束");
    }
//    if(jsonDate.participateId==null){
//        $("#watchMine").attr("style","display:none");
//    }else{
//        $("#watchMine").attr("style","display:block");
//    }
    if(jsonDate.participateId==null){
        $("#bigrank").html("");
        $("#whyreceive").html("");
        $("#preview").attr("style","display:none");
    }

};

//一共有多少人参与了活动
function xjhowmanyPeopleTake(ParticipateNum){
    patipateNum=ParticipateNum;
    if(DetailsJson.participateId!=null){
    $("#ParticipateNum").html("已参与"+ParticipateNum+"人");
    }
};

function xjHrefToShenMeGuia(){
    window.location.href = "searchpomoate.html";
};


function xjCheckPartInInZhuLQJS(xjZGDetailsJson) {
//     isdate = xjZGDetailsJson.buttonKey;
    if((xjZGDetailsJson.buttonKey=="b6")||(xjZGDetailsJson.buttonKey=="b8")){
        isdate = true;
    }
};


function xj_is_h5_xqPage() {
    xj_Is_H5_Page = true;
    
}

function xjGoBackBtnClick() {
    if(xj_Is_H5_Page){
        //执行其他代码
        location.href="nima://xjGoBackBtnClickInHFive";
    } else {
     history.back(-1);
    }
}
var xjxjxjsss ="";
function useUserId(userId,xjUserType) {
//    alert(userId);
    if(xjUserType=="comp") {
        isbussess = "comp";
    } else {
        isbussess = "person";
    }
    UserPerId = userId;
    if(DetailsJson.participateId==null){
    $("#ptPeople").html("已参与人数");
    $("#receiveNum").html(patipateNum);
    $("#ParticipateNum").html("");
    $("#bigrank").html("");
    }
//    alert(DetailsJson.userId);
    
    if(UserPerId==DetailsJson.userId&&isbussess==DetailsJson.userType){
        if(isdate){
            $("#whyreceive").html("您的活动，已经完美收官啦~");
        }else if(notdate){
            $("#whyreceive").html("您的活动还没开始，表捉急哦~");
        }else{
            $("#whyreceive").html("您的活动火爆进行中，要时时来关注哦~");
        }
    }
    
//    else if(DetailsJson.participateId==null&&!(UserPerId==DetailsJson.userId&&isbussess==DetailsJson.userType)){
//        $("#whyreceive").html("居然还没参与？猛戳右下角“立即参与“吧~");
//    }
    else if(DetailsJson.participateId==null&&!(UserPerId==DetailsJson.userId&&isbussess==DetailsJson.userType)&&isdate){
        xjxjxjsss="哎呀，来晚啦！下次要早点儿哦~";
    }
    else if(DetailsJson.participateId==null&&!(UserPerId==DetailsJson.userId&&isbussess==DetailsJson.userType)&&notdate){
        xjxjxjsss="哎呀,活动还没开始！先去看看活动规则吧~";
    }else if(DetailsJson.participateId==null&&!(UserPerId==DetailsJson.userId&&isbussess==DetailsJson.userType)){
       xjxjxjsss="居然还没参与？猛戳上一页右下角“立即参与“吧~";
    }
                 //    else {
//        xjxjxjsss=DetailsJson.participateId+','+UserId+','+DetailsJson.userId+','+isbussess+','+DetailsJson.userType+','+isdate;
//        xjxjxjsss="";
//    }
    
    $("#whyreceive").html(xjxjxjsss);
   
}

function xj_zlq_myrank(xj_zlq_rank_json) {
        rank=xj_zlq_rank_json.rank;
        getPnum=xj_zlq_rank_json.num;
        $("#rank").html(xj_zlq_rank_json.rank);
        if(DetailsJson.zlqRule=="TOP"&&!isdate){
            if(parseInt(DetailsJson.lowestNum)>getPnum){
                var chaNum=DetailsJson.lowestNum-getPnum;
                $("#whyreceive").html("还差"+chaNum+"个助力才有资格，拼颜值的时候到了");
            }else if(parseInt(DetailsJson.lowestNum)<=getPnum&&rank<=totalNum&&!isget){
                $("#whyreceive").html("人气爆棚的你，赶快去领取福利吧！");
            }else if(parseInt(DetailsJson.lowestNum)<=getPnum&&rank<=totalNum&&isget){
                $("#whyreceive").html("您已经领取过了~不要太贪心哈=-=");
            }else{
                $("#whyreceive").html("想要得到它吗？PK掉其他人吧！");
            }
        }else if(DetailsJson.zlqRule=="TOP"&&isdate){
            if(parseInt(DetailsJson.lowestNum)>getPnum){
                $("#whyreceive").html("明明可以靠脸吃饭，却偏偏要靠实力/(ㄒoㄒ)/~");
            }else if(parseInt(DetailsJson.lowestNum)<=getPnum&&rank<=totalNum){
                $("#whyreceive").html("人气爆棚的你，赶快去领取福利吧！");
            }else{
                $("#whyreceive").html("这次被别人反超了，下次活动一定要拿下它！");
            }
        }
        else{
            if(parseInt(DetailsJson.lowestNum)>getPnum&&!isdate){
                var chaNum=DetailsJson.lowestNum-getPnum;
                $("#whyreceive").html("还差"+chaNum+"个助力才能领取，转发到更多地方请求好友助力吧！");
            }else if(DetailsJson.lowestNum<=getPnum&&isget){
                
                $("#whyreceive").html("天下武功唯快不破！恭喜你达到领取资格！");
            }else{
//                alert(isget);
                $("#whyreceive").html("先下手为强，后下手遭殃，下次快点吧");
            }
        }
        
        xj_is_partIn = true;
}


function xj_pushSelfHelpList () {
    window.location.href = "zhuliqianglist.html";
}







