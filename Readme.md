# Anycubic Slicer Next for NixOS

Bu repository, NixOS üzerinde çalışacak şekilde özelleştirilmiş **Anycubic Slicer Next** yazılımını içerir.

## 📦 Paketleme Detayı

Bu proje, Ubuntu için hazırlanmış `.deb` paketini NixOS uyumlu hale getirmek için aşağıdaki teknikler kullanılarak oluşturulmuştur:

- **NixOS Derleme Sistemi**: `stdenv.mkDerivation` ile derleme
- **Kütüphane Bağlama**: `patchelf` ile dinamik kütüphaneler bağlanır
- **Kütüphane Yolları**: `LD_LIBRARY_PATH` ayarlamak yerine `patchelf --set-rpath` ile doğrudan binary içine entegre edilir
- **Uyumlu Kütüphaneler**: GTK3, GL, X11, zlib ve diğer gerekli kütüphaneler

## 📁 Dosya Yapısı

```
.
├── flake.nix          # NixOS yapılandırması ve paketleme kuralları
├── README.md          # Bu dokümantasyon dosyası
└── result/            # Derlenmiş uygulama dosyası
    └── bin/
        └── anycubic   # Çalıştırılabilir dosya
```

## 🚀 Kullanım

1. **Derleme**:
   ```bash
   nix build
   ```

2. **Çalıştırma**:
   ```bash
   ./result/bin/anycubic
   ```

3. **Geliştirme Ortamı (isteğe bağlı)**:
   ```bash
   nix develop
   ```

## ⚙️ Gereksinimler

- NixOS 24.05 veya üstü
- `nix` paketi yüklü
- `flake-utils` ve `nixpkgs` modülleri

## 📝 Notlar

- Bu yazılım ücretsiz olmayan (unfree) bir yazılımdır.
- `nix build` sırasında `config.allowUnfree = true` ayarı gereklidir.
- Uygulama, NixOS'un kendi `patchelf` sistemini kullanarak çalışır.
- Eğer kütüphane hataları alınıyorsa, `appDependencies` listesine gerekli kütüphaneleri ekleyebilirsiniz.

## 📚 Kaynaklar

- [Anycubic Slicer Next Resmi Site](https://anycubic.com)
- [NixOS Dokümantasyonu](https://nixos.org/manual/nixos/stable/)
- [Nix Paketleme Kılavuzu](https://nix.dev/)

---------------------------------------------------------------------------------------------------------

# Anycubic Slicer Next for NixOS

This repository contains the **Anycubic Slicer Next** software customized to run on NixOS.

## 📦 Packaging Details

This project was created by adapting the Ubuntu `.deb` package to be compatible with NixOS using the following techniques:

- **NixOS Build System**: Compilation using `stdenv.mkDerivation`
- **Library Linking**: Dynamic libraries are linked using `patchelf`
- **Library Paths**: Instead of setting `LD_LIBRARY_PATH`, libraries are directly embedded into the binary using `patchelf --set-rpath`
- **Compatible Libraries**: GTK3, GL, X11, zlib and other required libraries

## 📁 File Structure

```
.
├── flake.nix          # NixOS configuration and packaging rules
├── README.md          # This documentation file
└── result/            # Compiled application files
    └── bin/
        └── anycubic   # Executable file
```

## 🚀 Usage

1. **Build**:
   ```bash
   nix build
   ```

2. **Run**:
   ```bash
   ./result/bin/anycubic
   ```

3. **Development Environment (optional)**:
   ```bash
   nix develop


## ⚙️ Requirements

- NixOS 24.05 or higher
- `nix` package installed
- `flake-utils` and `nixpkgs` modukes

## 📝 Notes

- This software is proprietary (unfree).
- The `config.allowUnfree = true` setting is required during `nix build`.
- The application runs using NixOS's own `patchelf` system.
- If library errors occur, you can add required libraries to the `appDependencies` list.

## 📚 Resources

- [Anycubic Slicer Next Official Site](https://anycubic.com)
- [NixOS Documentation](https://nixos.org/manual/nixos/stable/)
- [Nix Packaging Guide](https://nix.dev/)
