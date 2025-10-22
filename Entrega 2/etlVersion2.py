import pandas as pd
import numpy as np
import csv

# Paths
INPUT_CSV = "movXArticuloConDetalleSeptiembre.csv"
OUTPUT_CSV = "datosLimpios.csv"

def main():
    print("ETL: Inicio del proceso")

    # --- 1. EXTRACT ---
    print(f"Lectura del archivo CSV: {INPUT_CSV}")
    df = pd.read_csv(INPUT_CSV, sep=";", encoding="latin1", dtype={'Nit': 'string'})
    print("\n--- Datos Originales (primeras filas) ---")
    print(df.head())

    # --- 2. TRANSFORM ---
    # Map from CSV headers to database field names
    column_mapping = {
        'C': 'idMovimiento',
        'Código': 'idProducto',
        'Unidad': 'unidadProducto',
        'Nombre': 'nombreProducto',
        'Bodega': 'bodega',
        'Saldo Ini': 'cantidadInventario',
        'Entradas': 'cantidadEntrada',
        'Salidas': 'cantidadSalida',
        'Saldo Final': 'cantidadFinal',
        'Tipo Doc.': 'tipoMovimiento',
        'Fecha': 'fecha',
        'Concepto': 'concepto',
        'Nit': 'nitTercero',
        'Tercero': 'nombreTercero',
        'COSTO': 'valorUnitario'
    }

    df_filtered = df[list(column_mapping.keys())].copy()
    df_filtered.rename(columns=column_mapping, inplace=True)

    # Derived fields
    df_filtered["cantidadNetaMovimiento"] = (
        df_filtered["cantidadEntrada"].fillna(0) - df_filtered["cantidadSalida"].fillna(0)
    )

    # Drop unused columns
    df_filtered.drop(columns=["cantidadEntrada", "cantidadSalida"], inplace=True)

    # Reorder for clarity (and to match logical DB relationships)
    column_order = [
        'idMovimiento',
        'idProducto',
        'nombreProducto',
        'unidadProducto',
        'bodega',
        'cantidadInventario',
        'cantidadFinal',
        'cantidadNetaMovimiento',
        'tipoMovimiento',
        'fecha',
        'concepto',
        'nitTercero',
        'nombreTercero',
        'valorUnitario'
    ]
    df_filtered = df_filtered[column_order]

    # --- Clean and normalize ---
    df_filtered['fecha'] = pd.to_datetime(df_filtered['fecha'], format='%Y/%m/%d', errors='coerce').dt.date

    # Strip whitespace
    for col in df_filtered.select_dtypes(include=["object", "string"]).columns:
        df_filtered[col] = df_filtered[col].astype(str).str.strip()

    # Replace empty strings with NA
    df_filtered.replace({"": pd.NA}, inplace=True)

    # Convert numerics
    numeric_cols = ['idMovimiento', 'cantidadInventario', 'cantidadFinal', 'cantidadNetaMovimiento', 'valorUnitario']
    for col in numeric_cols:
        df_filtered[col] = pd.to_numeric(df_filtered[col], errors='coerce')

    # Convert strings consistently
    string_cols = [
        'idProducto', 'nombreProducto', 'unidadProducto', 'bodega',
        'tipoMovimiento', 'concepto', 'nitTercero', 'nombreTercero'
    ]
    for col in string_cols:
        df_filtered[col] = df_filtered[col].astype("string")

    for col in df_filtered.columns:
        df_filtered[col] = df_filtered[col].replace(['<NA>', 'nan', 'NaN', 'None'], np.nan)

    # Sort by idMovimiento
    df_filtered.sort_values(by='idMovimiento', inplace=True)

    # --- 3. LOAD (to CSV) ---
    df_filtered.to_csv(OUTPUT_CSV, index=False, encoding='utf-8', sep=',', quoting=csv.QUOTE_ALL)
    print(f"\nArchivo limpio exportado como: {OUTPUT_CSV}")

    print("\n--- Vista previa de los datos limpios ---")
    print(df_filtered.head(15))

if __name__ == "__main__":
    main()