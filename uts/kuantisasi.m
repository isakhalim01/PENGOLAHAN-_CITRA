% Membaca citra
img = imread('D:\gambar\godong.jpg');

% Konversi ke grayscale jika belum
if size(img, 3) == 3
    img_gray = rgb2gray(img);
else
    img_gray = img;
end

% Fungsi untuk mengkuantisasi citra ke n tingkat keabuan
function quantized_img = quantize_gray(img_gray, levels)
    step = 256 / levels;
    quantized_img = floor(double(img_gray) / step) * step;
    quantized_img = uint8(quantized_img);
end

% Kuantisasi menjadi 2, 4, dan 8 tingkat keabuan
img_2 = quantize_gray(img_gray, 2);
img_4 = quantize_gray(img_gray, 4);
img_8 = quantize_gray(img_gray, 8);

% Tampilkan hasil
figure;
subplot(2,2,1), imshow(img_gray), title('Asli - Grayscale');
subplot(2,2,2), imshow(img_2), title('2 Tingkat Keabuan');
subplot(2,2,3), imshow(img_4), title('4 Tingkat Keabuan');
subplot(2,2,4), imshow(img_8), title('8 Tingkat Keabuan');

