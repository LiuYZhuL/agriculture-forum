// web/static/js/login.js

document.addEventListener("DOMContentLoaded", function () {
    const form = document.querySelector("form");
    if (form) {
        form.addEventListener("submit", function (e) {
            const password = document.querySelector("input[name='password']").value;

            // 自定义密码校验规则
            const passwordRegex = /^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$/;
            if (!passwordRegex.test(password)) {
                e.preventDefault();
                alert("密码至少包含一位字母和一位数字，且长度不少于8位");
            }
        });
    }
});
