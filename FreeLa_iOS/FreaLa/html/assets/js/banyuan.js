

window.onload = function () {
    //获取活动详情
    var jsonDate="";lowestNum=0;avgNum=0;nicenum=0;
    
    var istrue = true;
    var z_ptop = document.querySelector("#gundongdiv");
    //获取可视化区域
    var z_client = parseInt(getClient().height / 2.3);
    //被卷去的高度
    var z_scroll = getScrool().top;
    var z_recttop = 0;
    window.addEventListener('touchstart', function (e) {
                            
                            console.log("准备开始")
                            });
    window.addEventListener('touchmove', function (e) {
                            
                            //被卷去的高度
                            z_scroll = getScrool().top;
                            //                console.log(document.querySelector("p").getBoundingClientRect().top);
                            //元素距离可视化顶部区域的距离
                            z_recttop = z_ptop.getBoundingClientRect().top;
                            if (istrue) {
                            //增加数据搜索判断
                            if (z_recttop <= z_client&& document.body.clientHeight > z_client*1.5) {
                            istrue = false;
                            var set = setInterval(function () {
                                                  var steep = (z_recttop - z_scroll) / 10;
                                                  steep = steep > 0 ? Math.ceil(steep) : 5;
                                                  steep = steep + getScrool().top;
                                                  window.scrollTo(0, steep);
                                                  if (z_ptop.getBoundingClientRect().top - 10 <= 0) {
                                                  clearInterval(set);
                                                  document.querySelector(".ipt").style.top = 0 + "px";
                                                  document.querySelector(".ipt").style.position = "fixed";
                                                  document.querySelector(".ipt").style.display = "block";
                                                  }
                                                  
                                                  }, 20)
                            }
                            }
                            if (z_recttop >= z_client) {
                            istrue = true;
                            }
                            //判断用户是否网上拉动了一小块
                            if (z_recttop >= 50) {
                            document.querySelector(".ipt").style.display = "none";
                            } else if (z_recttop <= 20) {
                            document.querySelector(".ipt").style.display = "block";
                            }
                            console.log("开始滑动")
                            });
    
    window.onscroll = function () {
        //元素距离可视化顶部区域的距离
        z_recttop = z_ptop.getBoundingClientRect().top;
        if (z_recttop >= 50) {
            document.querySelector(".ipt").style.display = "none";
        } else if (z_recttop <= 20) {
            document.querySelector(".ipt").style.top = 0 + "px";
            document.querySelector(".ipt").style.position = "fixed";
            document.querySelector(".ipt").style.display = "block";
        }
    };
    window.addEventListener('touchend', function () {
                            console.log("滑动结束")
                            });

};

var xj_help_number_mine;
var xj_help_number_total;
var xj_help_number_lowestNum;
function xjSetBanYuanInfo(xjBanYuanDic){
    xj_help_number_mine = xjBanYuanDic.assiNum;
    if(xj_help_number_mine==0){
       xj_help_number_mine=0.000000001;
    }
    xj_help_number_total = xjBanYuanDic.topicNum;   //topicNum
    xj_help_number_lowestNum = xjBanYuanDic.lowestNum;   //lowestNum
    detailsForZ();
};
//
function detailsForZ(){
    var opts = {
    lines: 12, // The number of lines to draw
    angle: 0.25, // The length of each line
    lineWidth: 0.05, // The line thickness
    pointer: {
    length: 0.9, // The radius of the inner circle
    strokeWidth: 0.035, // The rotation offset
    color: '#000000' // Fill color
    },
    limitMax: 'false',   // If true, the pointer will not go past the end of the gauge
    colorStart: '#E94D47',   // Colors
    colorStop: '#E94D47',    // just experiment with them
    strokeColor: '#FDE7E7',   // to see which ones work best for you
    generateGradient: true
    };
    var target = document.getElementById('canvas-preview'); // your canvas element
    var gauge = new Donut(target).setOptions(opts); // create sexy gauge!
    gauge.maxValue = xj_help_number_lowestNum > xj_help_number_mine ? xj_help_number_lowestNum : xj_help_number_mine; // set max gauge value
    gauge.animationSpeed = 50; // set animation speed (32 is default value)
    gauge.set(xj_help_number_mine); // set actual value$.fn.gauge = function(opts) {
    
}

