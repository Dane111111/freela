
        function stopBubble(e) {

            // 如果提供了事件对象，则这是一个非IE浏览器

            if ( e && e.stopPropagation ) {

                // 因此它支持W3C的stopPropagation()方法

                e.stopPropagation();

            } else {

                // 否则，我们需要使用IE的方式来取消事件冒泡

                window.event.cancelBubble = true;

            }

        }


window.onload = function () {

    var istrue = true,islock = true;
    var z_ptop = document.querySelector(".watch_img");
    //document.body.innerHTML += "<div style='position:absolute;left:0;width:3000px;height:3000px;opacity:1;background:red;z-index:9999999999;'></div>"
    //获取可视化区域
    var z_client = parseInt(getClient().height / 2);
    console.log("总高度："+getClient().height);
    //被卷去的高度
    var z_scroll = getScrool().top;
    var z_recttop = 0;
    var set = "";
    window.addEventListener('touchstart', function (e) {
                            
//                            console.log("准备开始")
                            });
    window.addEventListener('touchmove', function (e) {
                            console.log( "呵呵呵呵呵呵呵"+islock);
                            
                            
                            if(islock){
                         
                            //被卷去的高度
                            z_scroll = getScrool().top;
                             console.log("被卷去的高度:"+z_scroll);
                            //               console.log(document.querySelector("p").getBoundingClientRect().top);
                            //元素距离可视化顶部区域的距离
                            z_recttop = z_ptop.getBoundingClientRect().top;
                            
                            console.log("元素距离可视化底部区域的距离:"+z_ptop.getBoundingClientRect().bottom);
//                            console.log("yuansu" + z_recttop);
                            if (istrue) {
                            if (z_recttop <= z_client) {
                           
                            istrue = false;
                            set = setInterval(function () {
                                              var steep = (z_scroll - z_recttop) / 90;
                                              if(steep < 0){
                                              steep = -steep;
                                              }
                                              steep = steep > 0 ? Math.ceil(steep) : Math.floor(steep)||5;
                                              console.log("刚开始：" + steep);
                                              steep = steep + getScrool().top;
                                              console.log("计算后要移动到的位置：" + steep);
                                              window.scrollTo(0, steep);
                                              islock = false;
                                              console.log("元素距离可视化顶部区域的距离:"+z_ptop.getBoundingClientRect().top);
                                              if (z_ptop.getBoundingClientRect().top - 10 <= 0) {
                                                clearInterval(set);
                                              }
                                              
                                              }, 20)
                            }
                            }
                            }else{
                            // 如果提供了事件对象，则这是一个非IE浏览器
                            clearInterval(set);
                            console.log("停止");
                            }
                            if (z_recttop >= z_client) {
                            istrue = true;
                            islock = true;
                            }
                            });
    
    window.onscroll = function () {
        //元素距离可视化顶部区域的距离
        z_recttop = z_ptop.getBoundingClientRect().top;
    };
    window.addEventListener('touchend', function () {
//                            console.log("滑动结束")
                            });
    
    
    
    
}
function stopBubble(e) {
    
    // 如果提供了事件对象，则这是一个非IE浏览器
    
    if ( e && e.stopPropagation ) {
        
        // 因此它支持W3C的stopPropagation()方法
        
        e.stopPropagation();
        
    } else {
        
        // 否则，我们需要使用IE的方式来取消事件冒泡
        
        window.event.cancelBubble = true;
        
    }
    
    
}

function xjSetProgressInHtml(xjFloatReceive) {
    
    xjSetProgressWithFloat(xjFloatReceive);
}

function xjSetProgressWithFloat(xjxjxjFolat) {
    var syj = {};
    //进度条,parent进度条的父控件对象,width进度条的宽度,barClass进度条的css,display是否显示进度条
    syj.ProgressBar = function (parent, width, barClass, display) {
        this.parent = parent;
        this.pixels = width;
        this.parent.innerHTML = "<div style='background: #FDE7E7;border-radius: 25px;height: 10px;'></div>";
        this.outerDIV = this.parent.childNodes[0];
        this.outerDIV.innerHTML = "<div style='border-radius: 25px;height: 10px;line-height: 10px;'><span style='border: 1px solid #E94D47;background: #FDE7E7;margin-top: -5px;padding: 4px;border-radius:25px;font-size:12px;'></span></div>";
        this.fillDIV = this.outerDIV.childNodes[0];
        this.fillDIVSPAN = this.fillDIV.childNodes[0];
        this.fillDIVSPAN.innerHTML = "0";
        this.fillDIV.style.width = "0px";
        this.outerDIV.className = barClass;
        this.outerDIV.style.width = (width + 2) + "px";
        this.parent.style.display = display == false ? 'none' : '';
    }
    //更新进度条进度 pct的值要介于0和1之间
    syj.ProgressBar.prototype.setPercent = function (pct, progress) {
        this.pixels = document.querySelector("#progressBar").offsetWidth;
        var fillPixels;
        if (pct < 1.0) {
            fillPixels = Math.round(this.pixels * pct);
        } else {
            pct = 1.0;
            fillPixels = this.pixels;
        }
        this.fillDIVSPAN.innerHTML = Math.ceil(100 * pct) + "%";
        this.fillDIV.style.width = fillPixels + "px";
        if (window.count == progress) {
            clearInterval(window.thread);
            window.thread = null;
            window.count = null;
        }
    }
    //初始化进度条
    function init() {
        window.jtProBar = new syj.ProgressBar(document.getElementById("progressBar"), "100%", "bgBar");
    }
    /****************************************************************************************/
    //下面代码为演示程序
    //开始演示
    function startAutoDemo(progress, speed) {
        if (window.thread == null) {
            window.thread = window.setInterval(function () {
                                               updatePercent(progress)
                                               }, speed);
        }
    }
    //演示程序
    function updatePercent(progress) {
        if (window.count == null) {
            window.count = 0
        }
        window.count = count % 101;
        jtProBar.setPercent(window.count / 100, progress);
        window.count++;
    }
    /****************************************************************************************/
    //初始化进度条
    init();
    //第一个参数：进度
    startAutoDemo(xjxjxjFolat, 30);
}
