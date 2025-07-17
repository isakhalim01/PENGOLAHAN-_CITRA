import cv2
import numpy as np
import os
import tkinter as tk
from tkinter import filedialog, Label, Button
from PIL import Image, ImageTk, ImageDraw, ImageFont

# === FUNGSI EKSTRAKSI HISTOGRAM ===
def extract_histogram(image_path):
    img = cv2.imread(image_path)
    if img is None:
        return None
    img = cv2.resize(img, (200, 200))
    hist = cv2.calcHist([img], [0, 1, 2], None, [8, 8, 8], [0, 256, 0, 256, 0, 256])
    hist = cv2.normalize(hist, hist).flatten()
    return hist

# === RETRIEVE GAMBAR MIRIP ===
def retrieve_similar(query_path):
    query_hist = extract_histogram(query_path)
    if query_hist is None:
        return []

    distances = []
    for hist in features:
        d = cv2.compareHist(query_hist, hist, cv2.HISTCMP_CORREL)
        distances.append(d)

    idxs = np.argsort(distances)[::-1][:5]
    result_paths_scores = [(paths[i], distances[i]) for i in idxs]
    return result_paths_scores

# === PILIH DATASET VIA GUI ===
def select_dataset():
    folder_selected = filedialog.askdirectory()
    if folder_selected:
        load_dataset(folder_selected)

# === LOAD DATASET DAN EKSTRAK HISTOGRAM ===
def load_dataset(folder):
    global features, paths
    features = []
    paths = []
    for img_name in os.listdir(folder):
        img_path = os.path.join(folder, img_name)
        if not os.path.isfile(img_path):
            continue
        if not img_name.lower().endswith(('.png', '.jpg', '.jpeg', '.bmp')):
            continue
        hist = extract_histogram(img_path)
        if hist is not None:
            features.append(hist)
            paths.append(img_path)
    btn_query.config(state=tk.NORMAL)
    lbl_info.config(text=f"Dataset berhasil dimuat: {len(paths)} gambar")

# === PILIH QUERY DAN TAMPILKAN HASIL ===
def browse_and_retrieve():
    filepath = filedialog.askopenfilename()
    if filepath:
        similar_imgs_scores = retrieve_similar(filepath)
        display_results(similar_imgs_scores, filepath)

# === TAMPILKAN HASIL PADA GRID & SIMPAN ===
def display_results(similar_imgs_scores, query_path):
    for widget in frame.winfo_children():
        widget.destroy()

    total_columns = 6  # 1 query + 5 hasil
    grid_img = Image.new('RGB', (total_columns * 160, 190 + 40), color=(255, 255, 255))

    try:
        font = ImageFont.truetype("arial.ttf", 12)
    except:
        font = ImageFont.load_default()

    # === TAMPILKAN GAMBAR QUERY ===
    img_query = Image.open(query_path).resize((150, 150))
    img_query_tk = ImageTk.PhotoImage(img_query)

    lbl_img_query = Label(frame, image=img_query_tk)
    lbl_img_query.image = img_query_tk
    lbl_img_query.grid(row=0, column=0, padx=5, pady=5)

    query_name = os.path.basename(query_path)
    lbl_text_query = Label(frame, text=f"Query:\n{query_name[:20]}", wraplength=150, justify="center")
    lbl_text_query.grid(row=1, column=0)

    grid_img.paste(img_query, (0, 0))
    draw = ImageDraw.Draw(grid_img)
    draw.text((5, 155), f"Query: {query_name[:20]}", fill=(0, 0, 0), font=font)

    # === TAMPILKAN 5 GAMBAR HASIL ===
    for idx, (img_path, score) in enumerate(similar_imgs_scores):
        img = Image.open(img_path).resize((150, 150))
        img_tk = ImageTk.PhotoImage(img)

        lbl_img = Label(frame, image=img_tk)
        lbl_img.image = img_tk
        lbl_img.grid(row=0, column=idx + 1, padx=5, pady=5)

        file_name = os.path.basename(img_path)
        score_text = f"{file_name[:15]}\nScore: {score:.4f}"
        lbl_text = Label(frame, text=score_text, wraplength=150, justify="center")
        lbl_text.grid(row=1, column=idx + 1)

        grid_img.paste(img, ((idx + 1) * 160, 0))
        draw.text(((idx + 1) * 160 + 5, 155), score_text.replace("\n", " "), fill=(0, 0, 0), font=font)

    # Simpan hasil grid
    grid_img.save("hasil_grid.png")
    lbl_info.config(text="Hasil CBIR disimpan sebagai 'hasil_grid.png' untuk laporan")

# === GUI SETUP ===
root = tk.Tk()
root.title("CBIR Fashion Finder - Praktikum CBIR")
root.geometry("1000x450")

btn_dataset = Button(root, text="Pilih Folder Dataset", command=select_dataset)
btn_dataset.pack(pady=5)

btn_query = Button(root, text="Pilih Gambar Query", command=browse_and_retrieve, state=tk.DISABLED)
btn_query.pack(pady=5)

lbl_info = Label(root, text="Silakan pilih folder dataset terlebih dahulu", fg="blue")
lbl_info.pack(pady=5)

frame = tk.Frame(root)
frame.pack()

# Inisialisasi list fitur dan paths
features = []
paths = []

root.mainloop()
