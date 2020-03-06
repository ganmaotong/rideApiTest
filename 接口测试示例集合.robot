*** Settings ***
Library           RequestsLibrary

*** Variables ***
${host}           https://postman-echo.com
${httpbin}        http://httpbin.org

*** Test Cases ***
get请求
    &{data}=    Create Dictionary    userId=yidd    password=passwd
    Create Session    postman    ${host}
    ${resp}    Get Request    postman    /get    data=&{data}
    log    ${resp.json()}
    Should Be Equal As Strings    ${resp.json()["args"]["userId"]}    &{data}[userId]
    Should Be Equal As Strings    ${resp.json()["args"]["password"]}    &{data}[password]

示例
    #设置请求头
    &{header}=    Create Dictionary    Content-Type=application/x-www-form-urlencoded
    #会话别名为 nmb    接口所在服务器域名地址为：test.lemonban.com
    Create Session    nmb    http://test.lemonban.com    headers=${header}
    #准备请求数据
    &{data}=    Create Dictionary    username=18688710213    passwd=fe7ead29e825e0463d9d8fca37ee42f5
    #发送post请求，并用变量接收响应结果
    ${resp}    Post Request    nmb    ningmengban/mvc/user/register.json
    Log    ${resp.status_code}
    #获取本次的响应数据
    Log    ${resp.text}
    #将响应数据从字符串转换成python的字典对象
    Log    ${resp.json()}
    #断言 - 字符串相等
    Should Be Equal As Strings    ${resp.text}    {"success":true,"message":"注册成功","content":null,"object":null}
    #断言 - 从字典当中取出message的值，与 注册成功    是否相等。
    Should Be Equal As Strings    注册成功    ${resp.json()["message"]}

Digest Auth测试
    #认证参数
    ${auth}=    Create List    user    pass
    Create Digest Session    pe    https://postman-echo.com    ${auth}
    ${resp}=    Get Request    pe    /digest-auth
    log    ${resp.text}
    Should Be Equal As Strings    ${resp.status_code}    401

post请求
    &{payload}=    Create Dictionary    key1=yetong    key2=lydia
    Create Session    httpbin    http://httpbin.org
    ${resp}    Post Request    httpbin    /post    data=&{payload}
    log    ${resp.text}
    Should Contain    ${resp.json()['data']}    key1=yetong

上传文件
    #open函数不能打开含有中文路径的文件
    ${filePath}=    Set Variable    "./get-pip.py"
    #先转换编码格式    unicode(inpath , "utf8")
    ${upath}    Evaluate    unicode(${filePath},'utf8')
    ${file}    Evaluate    open(unicode(${filePath},'utf8') ,"rb")
    &{files}=    Create Dictionary    file=${file}
    Create Session    httpbin    ${httpbin}
    ${resp}    Post Request    httpbin    /post    files=&{files}
    log    ${resp.status_code}
    log    ${resp.content}

put请求
    &{data}=    Create Dictionary    key=yetong
    Create Session    httpbin    ${httpbin}
    ${resp}    Put Request    httpbin    /put    data=&{data}
    log    ${resp.status_code}
    log    ${resp.content}
