/**
 * Created by Administrator on 2016/1/1.
 */

//window.onload = function () {

//�˷������ie6��7��8������ getElementsByClassName
//name --- Ҫ��ȡ��ǩ��className
function getClassName(name) {
    //������Ƿ�֧��getElementsByClassName����
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

//�����ƶ�
//obj -- Ҫ�ƶ��ı�ǩ��target -- Ŀ�꣬speed -- �ƶ����ٶ�
function move(obj, json, speed) {
    clearInterval(obj.time);
    obj.time = setInterval(function () {
        for (var k in json) {
            //var leader = obj.offsetLeft;
            var target = json[k];
            var leader = parseInt(getStyle(obj, k)); //�����ȡ����10px parseInt���� 10
            var iLeft = (target - leader) / speed;
            iLeft = iLeft > 0 ? Math.ceil(iLeft) : Math.floor(iLeft);
            //obj.style.left = obj.offsetLeft + iLeft + "px";
            obj.style[k] = leader + iLeft + "px";
            if (leader == target) {
                clearInterval(obj.time);
                // isTrue = true  //����һ���������ڴ����ֲ�ͼ�û�����������⣬��Ҫʱ�⿪ע��
            }
        }
    }, 30)
}

//������ʱ��ȡ���ڵ���ҳ��߶Ⱥͱ��ڵ���ҳ����߿��
function getScrool() {
    if (window.pageYOffset != undefined) {
        //window.pageYOffset Ŀǰֻ��Google��FF�߼������֧�� IE6��7��8��֧��
        return {
            top: window.pageYOffset,
            left: window.pageXOffset
        }
    } else if (document.compatMode == "BackCompat") {
        //���������DTDģʽִ�д˶δ���
        return {
            top: document.body.scrollTop,
            left: document.body.scrollLeft
        }
    } else {
        //�������DTDģʽִ�д˶δ���
        return {
            top: document.documentElement.scrollTop,
            left: document.documentElement.scrollLeft
        }
    }
}
//��ȡ����䶯ʱ�Ŀ��ӻ����
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
//��ȡ�ⲿ��ʽ������ֵ
function getStyle(obj, value) {
    if (!obj.currentStyle) {
        return getComputedStyle(obj, null)[value];
    } else {
        return obj.currentStyle[value];
    }
}
//}