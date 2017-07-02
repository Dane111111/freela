//var BaseUrl = "http://192.168.20.53:8080";
//var BaseUrl = "http://59.108.126.36:8585";
//var BaseUrl = "http://59.108.126.36:8888";
//
var BaseUrl  ="";   //freela


$(document).ready(function(){
//window.details.zhuliperqiang();
                  $(document).scroll(function(){
                                     var top = document.body.scrollTop;
                                     if(top<200){
                                     $(".pull-left11").hide();
                                     }else if(top>200){
                                     $(".pull-left11").show();
                                     }
                                     });

                  
});

function perzhuliqiangInPerZLQJS(zhuliPerJson)
{
     var layoutper="";
    if(zhuliPerJson!=null){
        for(var i=0;i<zhuliPerJson.length;i++){
            var xjSource="";
            if(zhuliPerJson[i].sourceId==1 || zhuliPerJson[i].sourceId==8){
                xjSource = 'PC';
            } else if(zhuliPerJson[i].sourceId==2){
                xjSource = 'Android';
            } else if(zhuliPerJson[i].sourceId==3){
                xjSource = 'iOS';
            } else if(zhuliPerJson[i].sourceId==4){
                xjSource = 'QQ';
            } else if(zhuliPerJson[i].sourceId==5){
                xjSource = '微信';
            } else if(zhuliPerJson[i].sourceId==6){
                xjSource = '新浪';
            }
            
            layoutper+='<div class="pr-pinglun pr-media-width">'
            layoutper+='<div class="user-pinglun2" style="padding: 10px 0 6px 0;">'
              layoutper+='<div>'
             layoutper+='<div style="width: 46px;height: 46px;border-radius: 46px;overflow: hidden;background-size: contain;float: left;">'
            layoutper+='<img src="'+zhuliPerJson[i].avatar+'" width="46" height="46">'
            layoutper+='</div>'
            layoutper+='<div class="head-name1">'
            layoutper+='<p class="pr-spot-desc free_dis15">'+zhuliPerJson[i].nickname+'</p>'
            layoutper+='<p class="pr-spot-desc3 free_dis15">'+zhuliPerJson[i].createTime+'</p>'
            layoutper+='</div>'
            layoutper+='</div>'
            layoutper+='<div class="laiyuan"><span class="pr-spot-desc3 free_dis9">来自'+xjSource+'</span></div>'
            layoutper+='</div>'
            layoutper+='</div>'
            
            
//            layoutper+='<div class="pr-pinglun1 pr-media-width">'
//            layoutper+='<div class="user-pinglun2">'
//            layoutper+='<div class="user-head2">'
//            layoutper+='<div class="head-user2">'
//            layoutper+='<img src="'+zhuliPerJson[i].avatar+'" width="100" height="100">'
//            layoutper+='<div class="head-mask3"></div>'
//            layoutper+='</div>'
//            layoutper+='<div class="head-name1">'
//            layoutper+='<p class="pr-spot-desc free_dis15">'+zhuliPerJson[i].nickname+'</p>'
//            layoutper+='<p class="pr-spot-desc3 free_dis15">'+zhuliPerJson[i].createTime+'</p>'
//            layoutper+='</div>'
//            layoutper+='</div>'
//            layoutper+=' <div class="laiyuan"><span class="pr-spot-desc3 free_dis9">来自'+xjSource+'</span></div>'
//            layoutper+='</div>'
//            layoutper+='</div>'
        }
        $("#perzhuli").html(layoutper);
    }else{
        $("#perzhuli").html("");
    }
};


function flXQSetHelpListTitleInHTML(flmyNickName)
{
//    alert('sad');
    if(!flmyNickName||flmyNickName=="undefined") {
        $("#userName").html("我的助力列表");
    } else {
         $("#userName").html(flmyNickName+"的助力列表");
    }
   
}
