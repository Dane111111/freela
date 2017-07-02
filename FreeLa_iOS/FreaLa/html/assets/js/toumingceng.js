            window.onload = function () {
            //获取元素图片
            var z_lis = document.querySelectorAll(".swiper-wrapper div");
            var z_mask = document.querySelector("#z_mask");
            var z_show = document.querySelector("#z_show");
            var z_img = document.querySelectorAll("#z_show img");
            for (var i = 0; i < z_lis.length; i++) {
                z_lis[i].setAttribute("index", i);
                z_img[i].setAttribute("index", i);
                //循环添加click
                z_lis[i].addEventListener("click", function () {
                    z_mask.style.display = "block";
                    document.body.style.overflow = "hidden";
                    z_show.style.display = "block";
                    for (var j = 0; j < z_img.length; j++) {
                        z_img[j].style.display = "none";
                    }
                    z_img[this.getAttribute("index")].style.display = "block";
                })
            }
            //遮罩层
            z_mask.addEventListener("click", function (event) {
                var event = event || window.event;
                var targetId = event.target ? event.target.id : event.srcElement.id;
                if (targetId != "show") {
                    z_mask.style.display = "none";
                    document.body.style.overflow = "";
                    z_show.style.display = "none";
                }
            });
//            遮罩层 end
        };