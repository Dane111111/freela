/**
 * Created by Administrator on 2016/1/1.
 */

//window.onload = function () {

//此方法解决ie6、7、8不兼容 getElementsByClassName
//name --- 要获取标签的className
function getClassName(name) {
    //浏览器是否支持getElementsByClassName属性
    if (document.getElementsByClassName) {
        return document.getElementsByClassName(name);
    }
    var oTagName = document.getElementsByTagName("*");
    var arr = [];
    for (var i = 0; i < oTagName.length; i++) {
        var oClassName = oTagName[i].className.split(" ");
        for (var j = 0; j < oClassName.length; j++) {
            if (oClassName[j] == name) {
                arr.push(oTagName[i]);
            }
        }
    }
    return arr;
}

//缓速移动
//obj -- 要移动的标签，target -- 目标，speed -- 移动的速度
function move(obj, json, speed) {
    clearInterval(obj.time);
    obj.time = setInterval(function () {
        for (var k in json) {
            //var leader = obj.offsetLeft;
            var target = json[k];
            var leader = parseInt(getStyle(obj, k)); //例如获取的是10px parseInt后是 10
            var iLeft = (target - leader) / speed;
            iLeft = iLeft > 0 ? Math.ceil(iLeft) : Math.floor(iLeft);
            //obj.style.left = obj.offsetLeft + iLeft + "px";
            obj.style[k] = leader + iLeft + "px";
            if (leader == target) {
                clearInterval(obj.time);
                // isTrue = true  //这是一个锁，用于处理轮播图用户连续点击问题，需要时解开注释
            }
        }
    }, 30)
}

//鼠标滚动时获取被遮挡的页面高度和被遮挡的页面左边宽度
function getScrool() {
    if (window.pageYOffset != undefined) {
        //window.pageYOffset 目前只有Google、FF高级浏览器支持 IE6、7、8不支持
        return {
            top: window.pageYOffset,
            left: window.pageXOffset
        }
    } else if (document.compatMode == "BackCompat") {
        //浏览器不是DTD模式执行此段代码
        return {
            top: document.body.scrollTop,
            left: document.body.scrollLeft
        }
    } else {
        //浏览器是DTD模式执行此段代码
        return {
            top: document.documentElement.scrollTop,
            left: document.documentElement.scrollLeft
        }
    }
}
//获取窗体变动时的可视化宽度
function getClient() {
    if (window.innerHeight != undefined) {
        return {
            width: window.innerWidth,
            height: window.innerHeight
        }
    } else if (document.documentElement.clientHeight == "CSS1Compat") {
        return {
            width: document.documentElement.clientWidth,
            height: document.documentElement.clientWidth
        }
    } else {
        return {
            width: document.body.clientWidth,
            height: document.body.clientHeight
        }
    }
}
//获取外部样式计算后的值
function getStyle(obj, value) {
    if (!obj.currentStyle) {
        return getComputedStyle(obj, null)[value];
    } else {
        return obj.currentStyle[value];
    }
}
//}