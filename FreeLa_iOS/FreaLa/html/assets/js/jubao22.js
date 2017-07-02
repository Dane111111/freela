    /**
     *举报，填写领取信息的js
     **/
    $(document).ready(function(){
     //获取填写信息
        window.details.writeReceiveInfo();
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
        window.details.getText(content+"*"+$("#textarea1").val());
        });

        $("#info_submit").click(function(){
            var json = {},jsonName={},list = []; var bo=true;var phonebo=true;
            				$("#add_info input[type='text']").each(function() {
            					var _this = $(this), _key = _this.attr("key"),_keyName=_this.attr("keyName");
            					json[_key] = _this.val();
            					var myreg = /^1[3458]\d{9}$/;
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
              window.details.getReceiveInfo(jsonStr);
              window.details.inSertGet();
                         }else if(!bo){
                         swal("您有未填写的信息 ");
                         }
               });



     });


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
    var re = /37|38|39|40/g
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



    var info="";
    var ssss="";
    function writeReceive(receiveInfo){
       var layout="";
//       var jsonobj=JSON.stringify(receiveInfo);
//       alert(jsonobj);
       for(item in receiveInfo.data){
       var arr=item.split("#&#");
       if(arr[0]=="电话"){
       layout+='<dl >'
       layout+='<dt><span class="pr-spot-desc3 free_dis8">'+arr[0]+'</span></dt>'
       if(receiveInfo.data[item]==null){
       layout+='<dd><input type="text" name="phone" maxlength="11" key="'+arr[0]+'" keyName="'+arr[1]+'" onkeypress="number()" onkeyup="filterInput()" onchange="filterInput()" onbeforepaste="filterPaste()" onpaste="return false" ></dd>'
       }else{
       layout+='<dd><input type="text" name="phone" maxlength="11" key="'+arr[0]+'" keyName="'+arr[1]+'" value="'+receiveInfo.data[item]+'" onkeypress="number()" onkeyup="filterInput()" onchange="filterInput()" onbeforepaste="filterPaste()" onpaste="return false" ></dd>'
       }
       layout+='</dl>'
       }else{

       layout+='<dl >'
       layout+='<dt><span class="pr-spot-desc3 free_dis8">'+arr[0]+'</span></dt>'
       if(receiveInfo.data[item]==null){
        layout+='<dd><input type="text" maxlength="35" key="'+arr[0]+'" keyName="'+arr[1]+'"></dd>'
       }else{
       layout+='<dd><input type="text" maxlength="35" key="'+arr[0]+'" keyName="'+arr[1]+'" value="'+receiveInfo.data[item]+'"></dd>'
       }
       layout+='</dl>'
       }
    }
    $("#add_info").html(layout);
    }















