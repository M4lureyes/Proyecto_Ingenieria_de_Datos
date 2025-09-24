import pandas as pd
import sqlite3

INPUT_CSV = "movXArticuloConDetalleSeptiembre.csv"

def main():
    print("ETL: Inicio del proceso")

    # --- 1. EXTRACT ---
    print(f"Lectura del archivo CSV: {INPUT_CSV}")
    df = pd.read_csv(INPUT_CSV, sep=";", encoding="latin1", dtype={'Nit': 'string'})
    print("\n--- Datos Originales (primeras filas) ---")
    print(df.head())

    # --- 2. TRANSFORM ---
    # Mapping current columns to desired normalized schema columns
    column_mapping = {
        'C': 'codigoMov',
        'Código': 'codigoProdReal',
        'Unidad': 'unidadProdReal',
        'Nombre': 'nombreProdReal',
        'Bodega': 'bodega',
        'Saldo Ini': 'cantidadPrevia',
        'Entradas': 'cantidadEntrada',
        'Salidas': 'cantidadSalida',
        'Saldo Final': 'cantidadFinal',
        'Tipo Doc.': 'tipoMovimiento',
        'Prefijo': 'prefijo',
        'Número': 'numero',
        'Fecha': 'fecha',
        'Concepto': 'concepto',
        'Nit': 'nitTercero',
        'Tercero': 'nombreTercero',
        'COSTO': 'costo'
    }

    # Select only the relevant columns
    df_filtered = df[list(column_mapping.keys())].copy()

    # Rename columns to match schema
    df_filtered.rename(columns=column_mapping, inplace=True)

    # Reorder columns logically
    column_order = [
        'codigoMov',
        'codigoProdReal',
        'nombreProdReal',
        'unidadProdReal',
        'bodega',
        'cantidadPrevia',
        'cantidadEntrada',
        'cantidadSalida',
        'cantidadFinal',
        'tipoMovimiento',
        'prefijo',
        'numero',
        'fecha',
        'concepto',
        'nitTercero',
        'nombreTercero',
        'costo'
    ]

    df_filtered = df_filtered[column_order]

    # Sort by codigoMov (identifier)
    df_filtered.sort_values(by='codigoMov', inplace=True)

    # Inspect data types and max string lengths
    '''print("\n--- Inspección de tipos de datos y longitudes máximas ---")
    for col in df_filtered.columns:
        dtype = df_filtered[col].dtype
        if pd.api.types.is_string_dtype(df_filtered[col]):
            max_len = df_filtered[col].astype(str).str.len().max()
            print(f"{col:<15} | Tipo: {dtype} | Longitud máxima: {max_len}")
        else:
            print(f"{col:<15} | Tipo: {dtype}")'''

    # Transform date from a string to an actual date
    df_filtered['fecha'] = pd.to_datetime(df_filtered['fecha'], format='%Y/%m/%d', errors='coerce')
    for col in ['concepto', 'nombreTercero']:
        df_filtered[col] = df_filtered[col].fillna('').astype(str)
    
    '''
    print("\n--- Nuevamente inspeccionamos tipos de datos y longitudes máximas ---")
    for col in df_filtered.columns:
        dtype = df_filtered[col].dtype
        if pd.api.types.is_string_dtype(df_filtered[col]):
            max_len = df_filtered[col].astype(str).str.len().max()
            print(f"{col:<15} | Tipo: {dtype} | Longitud máxima: {max_len}")
        else:
            print(f"{col:<15} | Tipo: {dtype}")'''

    # Strip whitespace from all string columns
    for col in df_filtered.select_dtypes(include=["object"]).columns:
        df_filtered[col] = df_filtered[col].astype(str).str.strip()

    # Replace empty strings with NA
    df_filtered.replace({"": pd.NA}, inplace=True)

    # Convert fecha to datetime.date
    df_filtered['fecha'] = pd.to_datetime(df_filtered['fecha'], errors='coerce').dt.date

    # For codigoMov its int, but need to be sure there are no missing values
    df_filtered['codigoMov'] = pd.to_numeric(df_filtered['codigoMov'], errors='coerce').fillna(0).astype(int)

    # For other numerics, keep floats and handle NAs as 0-s
    for col in ['cantidadPrevia', 'cantidadEntrada', 'cantidadSalida', 'cantidadFinal', 'costo']:
        df_filtered[col] = pd.to_numeric(df_filtered[col], errors='coerce').fillna(0)

    # For numero, we need to keep leading 0's
    df_filtered['numero'] = df_filtered['numero'].astype(str).str.strip()

    # For the rest of string columns, convert to string dtype
    string_cols = ['codigoProdReal', 'nombreProdReal', 'unidadProdReal', 'bodega', 'tipoMovimiento', 'prefijo', 'concepto', 'nombreTercero']
    for col in string_cols:
        df_filtered[col] = df_filtered[col].astype("string")

    # df_filtered is now cleaned and ready to load 
    print(df_filtered.head(20))

    # --- 3. LOAD ---
    '''print(f"\nCargando a base de datos SQLite: {OUTPUT_DB} (tabla: {TABLE_NAME})")
    conn = sqlite3.connect(OUTPUT_DB)
    df.to_sql(TABLE_NAME, conn, if_exists="replace", index=False)
    conn.close()
    print("Carga finalizada")'''

    output_file_path = "movimientoInventarioSeptiembre.csv"
    df_filtered.to_csv(output_file_path, index=False, encoding='latin1')

if __name__ == "__main__":
    main()
