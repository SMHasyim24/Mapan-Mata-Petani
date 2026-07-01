<?php

namespace App\Exports;

use Maatwebsite\Excel\Concerns\FromCollection;
use Maatwebsite\Excel\Concerns\WithHeadings;
use Maatwebsite\Excel\Concerns\WithMapping;
use Maatwebsite\Excel\Concerns\WithStyles;
use PhpOffice\PhpSpreadsheet\Worksheet\Worksheet;

class MapReportExport implements FromCollection, WithHeadings, WithMapping, WithStyles
{
    protected $data;

    public function __construct($data)
    {
        $this->data = collect($data);
    }

    public function collection()
    {
        return $this->data;
    }

    public function headings(): array
    {
        return [
            'No',
            'Kota/Kabupaten',
            'Provinsi',
            'Total Laporan',
            'Penyakit Terbanyak',
            'Jumlah Penyakit Terbanyak',
            'Rincian Penyakit',
        ];
    }

    public function map($row): array
    {
        static $no = 0;
        $no++;

        $rincian = [];
        if (isset($row['diseases']) && is_array($row['diseases'])) {
            foreach ($row['diseases'] as $disease) {
                $rincian[] = $disease['name'] . ': ' . $disease['count'];
            }
        }

        return [
            $no,
            $row['city'] ?? 'Tidak Diketahui',
            $row['province'] ?? 'Tidak Diketahui',
            $row['total_reports'] ?? 0,
            $row['top_disease'] ?? '-',
            $row['top_disease_count'] ?? 0,
            implode(', ', $rincian),
        ];
    }

    public function styles(Worksheet $sheet)
    {
        return [
            // Style the first row as bold text.
            1    => ['font' => ['bold' => true]],
        ];
    }
}
