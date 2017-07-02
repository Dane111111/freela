      /**
        *createBy zhangruofei
        *createTime 2015-12-24
        *个人助力列表js
         **/
//      var BaseUrl="http://123.57.35.196:80";
//var BaseUrl = "http://192.168.20.79:8888";
//        var BaseUrl="http://192.168.20.79:8888";
//var BaseUrl  ="http://www.freela.com.cn";   //freela
        var xjSize_PageSize = 20;
      var BaseUrl="";
var xj_Is_H5_Page = false;
//var xj_current_page = "";

      $(document).ready(function(){
//      window.details.zhulitopicqiang();
                        window.location.href="nima://xjCanyuListTopicPartIn"; //调用js 传参
                        $(document).scroll(function(){
                        var top = document.body.scrollTop;
                        if(top<200){
                        $(".pull-left11").hide();
                        }else if(top>200){
                        $(".pull-left11").show();
                        }
                        });
                        
                        //滑动到底部的监听
                        $(window).scroll(function(){
                                         　　var scrollTop = $(this).scrollTop();
                                         　　var scrollHeight = $(document).height();
                                         　　var windowHeight = $(this).height();
                                         　　if(scrollTop + windowHeight == scrollHeight){
                                         //                                   location.href = "nima://xjLoadMoreHelpListInHTML";
                                         location.href = 'js-call:' + 'xjLoadMoreHelpListInHtmlZlq' + ':' + encodeURIComponent(xjCurrentPage);
                                         
                                         　　}
                                         });
                        
                        
      });

var xjCurrentPage="";
      function xjCanyuListTopicPartIn(zhuliPerJson,xjIsPartInFull){
      if(zhuliPerJson!=null){
          var layoutper="";
//                        alert(zhuliPerJson.length);
          if(zhuliPerJson.length >= xjSize_PageSize) {
             xjCurrentPage = zhuliPerJson.length / xjSize_PageSize;
//              alert(xjCurrentPage);
          }
//          alert(xjIsPartInFull);
          for(var i=0;i<zhuliPerJson.length;i++){
              layoutper+='<div class="pr-pinglun pr-media-width">'
              layoutper+='<div class="pr-container">'
              layoutper+='<div class="user-pinglun2" style="padding: 10px 0 8px 0;">'
              layoutper+='<div class="user-head2">'
              layoutper+='<div class="head-user2">'
              layoutper+='<img src="'+zhuliPerJson[i].avatar+'" width="46" height="46">'
              layoutper+='</div>'
              layoutper+='<div class="head-name1">'
              layoutper+='<p class="pr-spot-desc free_dis15">'+zhuliPerJson[i].nickname+'</p>'
              layoutper+='<p class="pr-spot-desc3 free_dis15">'+zhuliPerJson[i].createTime+'</p>'
              layoutper+='</div>'
              layoutper+='</div>'
              layoutper+='</div>'
              layoutper+='</div>'
              layoutper+='</div>'
          }
          $("#perzhuli").html(layoutper);
      } else {
      }
      }
function xjClickToShowMore(xjIsPartInFull){
//    alert(xjCurrentPage);
    //调用oc，传参当前页
     if(xjIsPartInFull) {
//         alert('满了');
    } else {
        var commandName="xjCallOCToShowMorePartInfo";
        location.href = 'js-call:' + commandName + ':' + encodeURIComponent(JSON.stringify(xjCurrentPage));
    }
}

function xj_is_h5_CYPage() {
    xj_Is_H5_Page = true;
    
}


function xjGoBackBtnClickInHfive () {
    if(xj_Is_H5_Page){
        //执行其他代码
        location.href="nima://xjGoBackBtnClickInHFive";
    } else {
        history.back(-1);
    }
}






