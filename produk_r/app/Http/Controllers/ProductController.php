<?php

namespace App\Http\Controllers;

use App\Models\Product;
use Illuminate\Http\Request;

class ProductController extends Controller
{
    // Fungsi untuk mendapatkan semua produk
    public function index()
    {
        return Product::all();
    }

    // Fungsi untuk menyimpan produk baru
    public function store(Request $request)
    {
        $product = Product::create($request->all());
        return response()->json($product, 201);
    }

    // Fungsi untuk mendapatkan satu produk berdasarkan ID
    public function show($id)
    {
        return Product::findOrFail($id);
    }

    // Fungsi untuk memperbarui produk
    public function update(Request $request, $id)
    {
        $product = Product::findOrFail($id);
        $product->update($request->all());
        return response()->json($product, 200);
    }

    // Fungsi untuk menghapus produk
    public function destroy($id)
    {
        Product::destroy($id);
        return response()->json(null, 204);
    }
}
