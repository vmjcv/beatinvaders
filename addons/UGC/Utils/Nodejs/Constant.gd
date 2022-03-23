tool
extends Reference

## 和nodejs交互的协议号
enum PROTOCOL {
	C_S_LOGIN_NODEJS = 1001, # 连接nodejs服务器（不使用这个协议号，只是留着而已）
	C_S_LOGIN_WALLET = 1002, # 连接钱包
	C_S_GET_COIN_AMOUNT = 1003, # 获得代币数量
	C_S_GET_ALL_NFT = 1004, # 获得所有的NFT
	C_S_BUY_COIN = 1005, # 购买代币
	C_S_BUY_NFT = 1006, # 购买NFT
	C_S_TRANSFER_COIN = 1007, # 转账代币
	C_S_UPLOAD_FILE = 1008, # 上传文件（ugc上传文件夹使用）
	C_S_DOWNLOAD_FILE = 1009, # 获取文件

	S_C_LOGIN_NODEJS = 2001, # 连接nodejs服务器 结果
	S_C_LOGIN_WALLET = 2002, # 连接钱包 结果
	S_C_GET_COIN_AMOUNT = 2003, # 获得代币数量 结果
	S_C_GET_ALL_NFT = 2004, # 获得所有的NFT 结果
	S_C_BUY_COIN = 2005, # 购买代币 结果
	S_C_BUY_NFT = 2006, # 购买NFT 结果
	S_C_TRANSFER_COIN = 2007, # 转账代币 结果
	S_C_UPLOAD_FILE = 2008, # 上传文件 结果
	S_C_DOWNLOAD_FILE = 2009, # 获取文件 结果

	S_C_UPDATE_WALLET_QR = 3001, # 在链接钱包途中更新qrcode
	S_C_UPDATE_COIN = 3002, # 更新代币数量
	S_C_UPDATE_NFT = 3003, # 更新NFT信息
	S_C_UPDATE_ACCOUNT = 3004, # 更新账号信息，包括链id等信息
}

const port = 8089
