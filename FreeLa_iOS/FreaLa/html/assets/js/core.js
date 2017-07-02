(function ($) {
    var DOLPHIN = {};
    var thisTool = DOLPHIN;

    // 基础配置
    DOLPHIN.defaults = {
        ajax: {
            param: {
                type: 'get',
                dataType: "json",
                data: {},
                contentType : "application/x-www-form-urlencoded; charset=utf-8",
                async: false
            }
        }
    };
    //异步请求
    DOLPHIN.ajax = function (param) {
        var return_data = null;
        var defaultFunction = {
            success: function (reData, textStatus) {
                return_data = reData;
                if (reData.success) {
                    if (typeof param.onSuccess === 'function') {
                        param.onSuccess(reData);
                    }
                }
            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {
                if (textStatus == "parsererror" && XMLHttpRequest.status == 200) {
                    return_data = XMLHttpRequest.responseText;
                } else {
                    //提示 需自定义样式
                    //alert(textStatus)
                    return_data = textStatus;
                }
            }
        };
        var opts = $.extend({}, thisTool.defaults.ajax.param, defaultFunction, param);
        $.ajax(opts);
        return return_data;
    };
    window.Dolphin = DOLPHIN;
    window.TOOL = DOLPHIN;
})(jQuery);