### users

| 属性     | 类型   | 含义                  |
| -------- | ------ | --------------------- |
| ime      | String | 手机 IME 号，标识用户 |
| nickname | String | 昵称                  |

### messages

| 属性                | 类型    | 含义         |
| ------------------- | ------- | ------------ |
| user_id             | Integer | 用户 ID      |
| content             | text    | 留言内容     |
| latitude            | Float   | 纬度         |
| longitude           | Float   | 经度         |
| limit_user_accounts | Integer | 观看人数限制 |
| limit_days          | Integer | 存在天数     |
| is_delete           | Boolean | 是否删除     |

### errors

| status | info       |
| ------ | ---------- |
| 0      | success    |
| 1      | 用户不存在 |
