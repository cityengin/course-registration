import http.server
import socketserver
import threading
import time
import os
from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from PIL import Image

PORT = 8112
DIRECTORY = os.path.abspath(r"d:\DUT\KI-1-2026-2027\LTDNT\course-registration\build\web")
s = socketserver.TCPServer(("", PORT), lambda *args, **kwargs: http.server.SimpleHTTPRequestHandler(*args, directory=DIRECTORY, **kwargs))
threading.Thread(target=s.serve_forever, daemon=True).start()

opts = Options()
opts.add_experimental_option('mobileEmulation', {
    'deviceMetrics': {'width': 412, 'height': 915, 'pixelRatio': 2.0},
    'userAgent': 'Mozilla/5.0 (Linux; Android 14; Pixel 8) AppleWebKit/537.36'
})
opts.add_argument('--headless=new')
opts.add_argument('--disable-gpu')
opts.add_argument('--no-sandbox')
driver = webdriver.Chrome(options=opts)

def click_at(x, y):
    driver.execute_script(f"""
        const pane = document.querySelector('flt-glass-pane');
        const optsDown = {{ bubbles: true, cancelable: true, view: window, clientX: {x}, clientY: {y}, screenX: {x}, screenY: {y}, button: 0, buttons: 1, pointerId: 1, pointerType: 'mouse', isPrimary: true }};
        const optsUp = {{ bubbles: true, cancelable: true, view: window, clientX: {x}, clientY: {y}, screenX: {x}, screenY: {y}, button: 0, buttons: 0, pointerId: 1, pointerType: 'mouse', isPrimary: true }};
        pane.dispatchEvent(new PointerEvent('pointerdown', optsDown));
        pane.dispatchEvent(new MouseEvent('mousedown', optsDown));
        pane.dispatchEvent(new PointerEvent('pointerup', optsUp));
        pane.dispatchEvent(new MouseEvent('mouseup', optsUp));
        pane.dispatchEvent(new MouseEvent('click', optsUp));
    """)

def scroll_by(dy):
    driver.execute_script(f"""
        const pane = document.querySelector('flt-glass-pane');
        pane.dispatchEvent(new WheelEvent('wheel', {{ deltaY: {dy}, deltaMode: 0, clientX: 200, clientY: 500, bubbles: true, cancelable: true }}));
    """)

OUT_DIR = r"d:\DUT\KI-1-2026-2027\LTDNT\course-registration\screenshots"
os.makedirs(OUT_DIR, exist_ok=True)

try:
    print("Navigating to app...")
    driver.get(f"http://localhost:{PORT}")
    time.sleep(6) # wait for flutter web to fully initialize

    # 01_home_empty
    driver.save_screenshot(os.path.join(OUT_DIR, "01_home_empty.png"))
    print("01_home_empty saved")

    # 02_register_one: click Course 3 'Đăng ký' at (336, 504)
    click_at(336, 504)
    time.sleep(1)
    driver.save_screenshot(os.path.join(OUT_DIR, "02_register_one.png"))
    print("02_register_one saved")

    # 03_demo_valid: expand demo panel at (200, 105), then click 'Đăng ký đủ tối thiểu' at (135, 198)
    click_at(200, 105)
    time.sleep(0.8)
    click_at(135, 198)
    time.sleep(1)
    driver.save_screenshot(os.path.join(OUT_DIR, "03_demo_valid.png"))
    print("03_demo_valid saved")

    # 04_demo_exceed: click 'Thử vượt giới hạn' at (285, 198)
    click_at(285, 198)
    time.sleep(1)
    driver.save_screenshot(os.path.join(OUT_DIR, "04_demo_exceed.png"))
    print("04_demo_exceed saved")

    # 05_demo_duplicate: wait for snackbar to dismiss, then click 'Thử đăng ký trùng' at (130, 236)
    time.sleep(3.5)
    click_at(130, 236)
    time.sleep(1)
    driver.save_screenshot(os.path.join(OUT_DIR, "05_demo_duplicate.png"))
    print("05_demo_duplicate saved")

    # 06_registered: open RegisteredScreen at (340, 28)
    click_at(340, 28)
    time.sleep(1.5)
    driver.save_screenshot(os.path.join(OUT_DIR, "06_registered.png"))
    print("06_registered saved")

    # 07_sync_back: delete first course at (380, 145), then back at (25, 28)
    click_at(380, 145)
    time.sleep(1)
    click_at(25, 28)
    time.sleep(1.5)
    driver.save_screenshot(os.path.join(OUT_DIR, "07_sync_back.png"))
    print("07_sync_back saved")

    # 08_lab_initial: open ProviderLabScreen at (388, 28)
    click_at(388, 28)
    time.sleep(2)
    # Dismiss any tooltip by clicking neutral background at (206, 120)
    click_at(206, 120)
    time.sleep(0.5)
    driver.save_screenshot(os.path.join(OUT_DIR, "08_lab_initial.png"))
    print("08_lab_initial saved")

    # 09_lab_setstate: tap 3 times on 'Tăng số (setState)' at (206, 375)
    for _ in range(3):
        click_at(206, 375)
        time.sleep(0.4)
    time.sleep(1)
    driver.save_screenshot(os.path.join(OUT_DIR, "09_lab_setstate.png"))
    print("09_lab_setstate saved")

    # 10_lab_provider: tap 3 times on 'Tăng countA (context.read)' at (206, 612)
    for _ in range(3):
        click_at(206, 612)
        time.sleep(0.4)
    time.sleep(1)
    driver.save_screenshot(os.path.join(OUT_DIR, "10_lab_provider.png"))
    print("10_lab_provider saved")

    # 11_lab_increment_b: scroll down 1200px to Part 2, tap 'Tăng B (+1)' at (206, 800) 2 times
    scroll_by(1200)
    time.sleep(1)
    for _ in range(2):
        click_at(206, 800)
        time.sleep(0.4)
    time.sleep(1)
    driver.save_screenshot(os.path.join(OUT_DIR, "11_lab_increment_b.png"))
    print("11_lab_increment_b saved")

    # 12_lab_reset: click AppBar reset icon at (388, 28)
    click_at(388, 28)
    time.sleep(0.5)
    driver.save_screenshot(os.path.join(OUT_DIR, "12_lab_reset.png"))
    print("12_lab_reset saved")

    print("ALL 12 SCREENSHOTS COMPLETED SUCCESSFULLY!")

finally:
    driver.quit()
    s.shutdown()
