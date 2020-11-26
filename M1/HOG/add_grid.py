import cv2  #OpenCVのインポート

fname = "car.jpg" #画像ファイル名

y_step=100 #高さ方向のグリッド間隔(単位はピクセル)
x_step=100 #幅方向のグリッド間隔(単位はピクセル)

img = cv2.imread(fname) #画像を読み出しオブジェクトimgに代入
print(img.shape)
print(img.shape[:2])
#オブジェクトimgのshapeメソッドの1つ目の戻り値(画像の高さ)をimg_yに、2つ目の戻り値(画像の幅)をimg_xに
img_y,img_x=img.shape[:2]  

#横線を引く：y_stepからimg_yの手前までy_stepおきに白い(BGRすべて255)横線を引く
img[y_step:img_y:y_step, :, :] = 255
#縦線を引く：x_stepからimg_xの手前までx_stepおきに白い(BGRすべて255)縦線を引く
img[:, x_step:img_x:x_step, :] = 255

cv2.imwrite('grid.png',img) #ファイル名'grid.png'でimgを保存