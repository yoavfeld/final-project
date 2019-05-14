package main

import (
	"archive/zip"
	"fmt"
	"io"
	"io/ioutil"
	"log"
	"math"
	"os"
	"path/filepath"
	"strings"
)

func main() {

	path := "/Volumes/3T_data/"

	files, err := ioutil.ReadDir(path)
	if err != nil {
		log.Fatal(err)
	}

	for i, f := range files {
		filePath := path+f.Name()
		if filepath.Ext(filePath) != ".zip" {
			log.Printf("skip non zip file: %d %s", i, filePath)
			continue
		}
		log.Printf("start %d %s", i, filePath)
		_, err := Unzip(filePath, path)
		if err != nil {
			log.Fatal(err)
		}
		log.Printf("finish unzip %d %s", i, filePath)
		deleteFile(filePath) // deleting permanently
		log.Printf("finish deleting %d %s", i, filePath)
	}
}

func Unzip(src string, dest string) ([]string, error) {

	var filenames []string

	r, err := zip.OpenReader(src)
	if err != nil {
		return filenames, err
	}
	defer r.Close()

	for _, f := range r.File {

		// Store filename/path for returning and using later on
		fpath := filepath.Join(dest, f.Name)

		// Check for ZipSlip. More Info: http://bit.ly/2MsjAWE
		if !strings.HasPrefix(fpath, filepath.Clean(dest)+string(os.PathSeparator)) {
			return filenames, fmt.Errorf("%s: illegal file path", fpath)
		}

		filenames = append(filenames, fpath)

		if f.FileInfo().IsDir() {
			// Make Folder
			os.MkdirAll(fpath, os.ModePerm)
			continue
		}

		// Make File
		if err = os.MkdirAll(filepath.Dir(fpath), os.ModePerm); err != nil {
			return filenames, err
		}

		outFile, err := os.OpenFile(fpath, os.O_WRONLY|os.O_CREATE|os.O_TRUNC, f.Mode())
		if err != nil {
			return filenames, err
		}

		rc, err := f.Open()
		if err != nil {
			return filenames, err
		}

		_, err = io.Copy(outFile, rc)

		// Close the file without defer to close before next iteration of loop
		outFile.Close()
		rc.Close()

		if err != nil {
			return filenames, err
		}
	}
	return filenames, nil
}

func deleteFile(targetFile string) {

	// make sure we open the file with correct permission
	// otherwise we will get the
	// bad file descriptor error
	file, err := os.OpenFile(targetFile, os.O_RDWR, 0666)

	if err != nil {
			panic(err.Error())
	}

	defer file.Close()

	// find out how large is the target file

	fileInfo, err := file.Stat()
	if err != nil {
			panic(err)
	}

	// calculate the new slice size
	// base on how large our target file is

	var fileSize int64 = fileInfo.Size()
	const fileChunk = 1 * (1 << 20) // 1 MB, change this to your requirement

	// calculate total number of parts the file will be chunked into
	totalPartsNum := uint64(math.Ceil(float64(fileSize) / float64(fileChunk)))

	lastPosition := 0

	for i := uint64(0); i < totalPartsNum; i++ {

			partSize := int(math.Min(fileChunk, float64(fileSize-int64(i*fileChunk))))
			partZeroBytes := make([]byte, partSize)

			// fill out the part with zero value
			copy(partZeroBytes[:], "0")

			// over write every byte in the chunk with 0 
			//fmt.Println("Writing to target file from position : ", lastPosition)
			_, err := file.WriteAt([]byte(partZeroBytes), int64(lastPosition))

			if err != nil {
					panic(err.Error())
			}

			//fmt.Printf("Wiped %v bytes.\n", n)

			// update last written position
			lastPosition = lastPosition + partSize
	}

	// finally remove/delete our file
	err = os.Remove(targetFile)

	if err != nil {
			panic(err)
	}
}