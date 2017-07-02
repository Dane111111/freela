//jindutiao
window.onload = function(){
   //获取活动详情
	var assinum=0;lowestNum=0;avgNum=0;nicenum=0;

//    window.details.detailsForZLQ();
//    window.details.sendUserId2();
//     window.details.zhulitopicqiang2();
	var canvas = document.getElementById("canvas");
	var ctx = canvas.getContext("2d");
	var W = canvas.width;
	var H = canvas.height;
	var deg=0,new_deg=0,dif=0;
	var loop,re_loop;
	var text,text_w;
	var UserId=0;var DetailsJson="";
	
	function init(){
		ctx.clearRect(0,0,W,H);
		ctx.beginPath();
		ctx.strokeStyle="#d42a2b";
		ctx.lineWidth=12;
		ctx.arc(W/2,H/2,150,0,Math.PI*2,false);
		ctx.stroke();
		
		var r = deg*Math.PI/180;
		ctx.beginPath();
		ctx.strokeStyle = "#fff";
		ctx.lineWidth=12;
		ctx.arc(W/2,H/2,150,0-90*Math.PI/180,r-90*Math.PI/180,false);
		ctx.stroke();
		
		ctx.fillStyle="#fff";
		ctx.font="65px abc";
		text1 = Math.floor(deg/360*100);
        text="  "+lowestNum;
		text_w = ctx.measureText(text1).width;
		ctx.fillText(text,W/2 - text_w/2,H/2+15);
	}

	function draw(){
		new_deg = Math.round(avgNum*360);
		dif = new_deg-deg;
		loop = setInterval(to,1000/dif);
	}
	function to(){
		if(deg == new_deg){
			clearInterval(loop);
		}
		if(deg<new_deg){
			deg++;
		}
		init();
	}
//    alert("draw111"+totalNum);
	draw();
	re_loop = setInterval(draw,2000);
}
    function flGetJSXQInfomationCanyu(jsonDate){
    lowestNum=jsonDate.assiNum;
    nicenum=jsonDate.lowestNum;
    avgNum=lowestNum/nicenum;
        if(avgNum>1){
            avgNum=1;
        }
    }
//    function useUserId2(userId){
//    UserId=userId;
//    }
//    function topiczhuliqiang2(zhuliTopicJson){
//    if(zhuliTopicJson!=null){
//    ss=zhuliTopicJson;
//    var topicJson=zhuliTopicJson;
//    for(var i=0;i<topicJson.length;i++){
//             if(topicJson[i].userId==UserId){
//                assinum=topicJson[i].num;
//                if(nicenum>=assinum){
//                avgNum=assinum/nicenum;
//                }else{
//                avgNum=1;
//                      }
//              }
//          }
//       }
//    }



