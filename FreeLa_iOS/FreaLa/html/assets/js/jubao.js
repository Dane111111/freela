


var xj_Is_H5_Page = false;

$(document).ready(function(){
//$("#shandong").attr("class").indexOf("bg") ==22;
                  $(".pr-spot-desc3").removeClass("bg");
                  $(".pull-left2").click(function(){
//                                         alert('asd');
                                         FLMethodXQModel.flSethiddenWithNavi(0);
                                         });
                 
                  
//获取填写信息
 
                  
                  var content="";
                  $(".jubao li").click(function(){
                                       var $this = $(this);
                                       $this.siblings().removeClass("jubaoclick");
                                       $this.addClass("jubaoclick");
                                       $this.siblings().removeAttr("Ids");
                                       $this.attr("Ids","state");
                                       content =$('[Ids="state"]').find("a").html();
                                       });
                  $("#jubao_btn").click(function(){
//                                        alert(content);
//                                       FLMethodXQModel.getJubaoTextAndSendToService(content+"*"+$("#textarea1").val());
                                        if($("#textarea1").val()!=null&&$("#textarea1").val()!=""){
                                        location.href='js-call'+':'+'HTMLjubaoclick'+':'+encodeURIComponent(content+"*"+$("#textarea1").val());
                                        }else{
                                        swal("请说出你的宝贵意见")
                                        }
                                        });
                  
                  
                  
$("#info_submit").click(function(){
                        checkInfoToSubmitToPart();
});

 });

function jubaoClickBackToXQ()
{
    window.location.href='xiangqing.html';
};

//填写领取信息

function checkInfoToSubmitToPart(){
 
    var json = {},jsonName={},list = []; var bo=true;var phonebo=true;
    $("#add_info input[type='text']").each(function() {
                                           var _this = $(this), _key = _this.attr("key"),_keyName=_this.attr("keyName");
                                           json[_key] = _this.val();
                                           var myreg = /^1[34578]\d{9}$/;
                                           if(_key=="电话"){
                                           if(!myreg.exec(json[_key])&&json[_key]!=null){
                                           swal("请输入正确的手机号");
                                           phonebo=false;
                                           }
                                           }
                                           jsonName[_keyName] = _this.val();
                                           });
    list.push(json);
    list.push(jsonName);
    jsonStr=JSON.stringify(list);
    $('#add_info input[type="text"]').each(function(){
                                           var $this=$(this);
                                           if($.trim($this.val())==""||$.trim($this.val())==null){
                                           bo=false;
                                           return;
                                           }
                                           });
    if(bo&&phonebo){
        var commandName = 'setInfoAndSaveTopic';
        location.href = 'js-call:' + commandName + ':' + encodeURIComponent(jsonStr);
    }else if(!bo){
        swal("您有未填写的信息 ");
    }
    
    
};




var info="";
var ssss=""
function writeReceiveInJubaoJS(receiveInfo){
    var layout="";
    var aaa=receiveInfo+"";
    var arr = aaa.split(',');   // 字符串就转换成Array数组了。
    for(var i=0;i<arr.length;i++){
        var arrs=arr[i].split('#&#');
        layout+='<dl >'
        layout+='<dt><span class="pr-spot-desc3 free_dis8">'+arrs[0]+'</span></dt>'
        layout+='<dd><input type="text" maxlength="35" key="'+arrs[0]+'" keyName="'+arrs[1]+'"></dd>'
        layout+='</dl>'
    }
    
    $("#add_info").html(layout);

//    var layout="";
//    for(item in receiveInfo.data){
//        var arr=item.split("#&#");
//        if(arr[0]=="电话"){
//            layout+='<dl >'
//            layout+='<dt><span class="pr-spot-desc3 free_dis8">'+arr[0]+'</span></dt>'
//            if(receiveInfo.data[item]==null){
//                layout+='<dd><input type="text" name="phone" maxlength="11" key="'+arr[0]+'" keyName="'+arr[1]+'" onkeypress="number()" onkeyup="filterInput()" onchange="filterInput()" onbeforepaste="filterPaste()" onpaste="return false" ></dd>'
//            }else{
//                layout+='<dd><input type="text" name="phone" maxlength="11" key="'+arr[0]+'" keyName="'+arr[1]+'" value="'+receiveInfo.data[item]+'" onkeypress="number()" onkeyup="filterInput()" onchange="filterInput()" onbeforepaste="filterPaste()" onpaste="return false" ></dd>'
//            }
//            layout+='</dl>'
//        }else{
//            
//            layout+='<dl >'
//            layout+='<dt><span class="pr-spot-desc3 free_dis8">'+arr[0]+'</span></dt>'
//            if(receiveInfo.data[item]==null){
//                layout+='<dd><input type="text" maxlength="35" key="'+arr[0]+'" keyName="'+arr[1]+'"></dd>'
//            }else{
//                layout+='<dd><input type="text" maxlength="35" key="'+arr[0]+'" keyName="'+arr[1]+'" value="'+receiveInfo.data[item]+'"></dd>'
//            }
//            layout+='</dl>'
//        }
//    }
//    alert(layout);
    $("#add_info").html(layout);

};

function xjtextGoback(){
//    alert('s');
    location.href="xiangqing.html";
}



function number()
{
    var char = String.fromCharCode(event.keyCode)
    var re = /[0-9]/g
    event.returnValue = char.match(re) != null ? true : false
}

function filterInput()
{
    if (event.type.indexOf("key") != -1)
    {
        var re = /37|38|39|40|70/g
        if (event.keyCode.toString().match(re)) return false
            }
    event.srcElement.value = event.srcElement.value.replace(/[^0-9]/g, "")
}

function filterPaste()
{
    var oTR = this.document.selection.createRange()
    var text = window.clipboardData.getData("text")
    oTR.text = text.replace(/[^0-9]/g, "")
}

function xj_is_h5_JBPage() {
    xj_Is_H5_Page = true;
    
}

function xjGoBackBtnClickInJBPage() {
    if(xj_Is_H5_Page){
        //执行其他代码
        location.href="nima://xjGoBackBtnClickInHFive";
    } else {
        history.back(-1);
    }
}
function xjGoBackWithOutInfoError() {
     history.back(-1);
}


/*
var info="";
var arr=""
var ssss=""
function Deatils(jsonDate){
info=jsonDate.partInfo;
arr=info.split(",");
 //用户需要填写的信息
   var layout="";
   for(var i=0;i<arr.length;i++){
   if(arr[i]=="NAME"){
    layout+='<dl >'
      layout+='<dt><span class="pr-spot-desc3 free_dis8">姓名</span></dt>'

      layout+='<dd><input type="text" id="name'+i+'" key="姓名" value="s"></dd>'
      layout+='</dl>'
      $("#add_info").html(layout);
      }else if(arr[i]=="PHONE"){
       layout+='<dl >'
            layout+='<dt><span class="pr-spot-desc3 free_dis8">手机</span></dt>'
            layout+='<dd><input type="text" id="name'+i+'" key="手机" value=""></dd>'
            layout+='</dl>'
            $("#add_info").html(layout);
      }else if(arr[i]=="COMPANY"){
              layout+='<dl >'
                   layout+='<dt><span class="pr-spot-desc3 free_dis8">单位</span></dt>'
                   layout+='<dd><input type="text" id="name'+i+'" key="单位" value=""></dd>'
                   layout+='</dl>'
                   $("#add_info").html(layout);
             }else if(arr[i]=="POSITION"){
                     layout+='<dl >'
                          layout+='<dt><span class="pr-spot-desc3 free_dis8">职位</span></dt>'
                          layout+='<dd><input type="text" id="name'+i+'" key="职位" value=""></dd>'
                          layout+='</dl>'
                          $("#add_info").html(layout);
                    }else if(arr[i]=="COURSE"){
                            layout+='<dl >'
                                 layout+='<dt><span class="pr-spot-desc3 free_dis8">行业</span></dt>'
                                 layout+='<dd><input type="text" id="name'+i+'" key="行业" value=""></dd>'
                                 layout+='</dl>'
                                 $("#add_info").html(layout);
                           }else{
                           layout+='<dl >'
                            layout+='<dt><span class="pr-spot-desc3 free_dis8">'+arr[i]+'</span></dt>'
                            layout+='<dd><input type="text" id="name'+i+'" key="'+arr[i]+'" value=""></dd>'
                            layout+='</dl>'
                            $("#add_info").html(layout);
                           }
//   layout+='<dl >'
//   layout+='<dt><span class="pr-spot-desc3 free_dis8">'+arr[i]+'</span></dt>'
//   layout+='<dd><input type="text" id="name'+i+'" key="'+arr[i]+'" value="15843277899"></dd>'
//   layout+='</dl>'
//   $("#add_info").html(layout);
}

}

*/
   //用户需要填写的信息
//   var layout="";
//   var arr = new Array("姓名","电话","邮箱","IT行业")
//   for(var i=0;i<arr.length;i++){
//   layout+='<dl >'
//   layout+='<dt><span class="pr-spot-desc3 free_dis8">'+arr[i]+'</span></dt>'
//   layout+='<dd><input type="text" id="name'+i+'" key="'+arr[i]+'" value="15843277899"></dd>'
//   layout+='</dl>'
//   $("#add_info").html(layout);
//   }
//var json = {};
//				$("#add_info input[type='text']").each(function() {
//					var _this = $(this), _key = _this.attr("key");
//					json[_key] = _this.val();
//				})
//				massage = JSON.stringify(json);



 




