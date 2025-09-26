﻿
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using FastFood.Models;
using System.Diagnostics;

namespace FastFood.Controllers
{
    public class HomeController : Controller
    {
        private readonly ILogger<HomeController> _logger;
        private readonly QlbanDoAnContext _db;

        public HomeController(ILogger<HomeController> logger, QlbanDoAnContext db)
        {
            _logger = logger;
            _db = db;
        }

        // Trang chủ hiển thị danh mục + sản phẩm
        public IActionResult Index()
        {
            var danhMuc = _db.DanhMucs
                .Include(dm => dm.SanPhams)
                .ToList();

            return View(danhMuc); // ✅ Trả về model cho view
        }

        // Chi tiết sản phẩm
        public IActionResult ChiTietSanPham(int id)
        {
            var sp = _db.SanPhams
               .Include(s => s.MaDmNavigation)
               .FirstOrDefault(s => s.MaSp == id);


            if (sp == null) return NotFound();

            return View(sp); // ✅ Truyền 1 sản phẩm vào view
        }

        public IActionResult ThongTin()
        {
            return View();
        }
        public IActionResult TatCaSanPham()
        {
            var sanPhams = _db.SanPhams.ToList();
            return View(sanPhams);
        }

        public IActionResult Search(string keyword)
        {
            if (string.IsNullOrEmpty(keyword))
            {
                return RedirectToAction("Index");
            }

            var sanPhams = _db.SanPhams
                .Include(sp => sp.MaDmNavigation)
                .Where(sp => sp.TenSp.Contains(keyword) || sp.MoTa.Contains(keyword))
                .ToList();

            ViewBag.Keyword = keyword;
            return View(sanPhams);
        }

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }
    }
}
